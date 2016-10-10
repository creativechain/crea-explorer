<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\ObjectID;
use MongoDB\BSON\Regex;
use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\Account;
use SteemDB\Models\AccountHistory;
use SteemDB\Models\Block30d;
use SteemDB\Models\Comment;
use SteemDB\Models\CurationReward;
use SteemDB\Models\Pow;
use SteemDB\Models\Reblog;
use SteemDB\Models\Statistics;
use SteemDB\Models\Transfer;
use SteemDB\Models\Vote;
use SteemDB\Models\WitnessHistory;

class AccountApiController extends ControllerBase
{

  public function initialize()
  {
    header('Content-type:application/json');
    $this->view->disable();
    ini_set('precision', 20);
  }

  public function viewAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Account::findFirst([
      ['name' => $account]
    ]);
    echo json_encode($data->toArray(), JSON_PRETTY_PRINT);
  }

  public function witnessvotesAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Account::aggregate(array(
      ['$match' => [
          'witness_votes' => $account,
      ]],
      ['$project' => [
        'name' => '$name',
        'weight' => ['$sum' => ['$vesting_shares', '$proxy_witness']]
      ]],
      ['$sort' => ['weight' => -1]]
    ))->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function snapshotsAction() {
    $account = $this->dispatcher->getParam("account");
    $data = AccountHistory::find([
      ['account' => $account],
      'sort' => ['date' => 1],
      'limit' => 100
    ]);
    foreach($data as $idx => $document) {
      $data[$idx] = $document->toArray();
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function historyAction() {
    $account = $this->dispatcher->getParam("account");
    $data = AccountHistory::aggregate([
      [
        '$match' => [
          'name' => $account
        ]
      ],
      [
        '$project' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$date'],
            'year' => ['$year' => '$date'],
            'month' => ['$month' => '$date'],
            'day' => ['$dayOfMonth' => '$date'],
          ],
          'posts' => '$post_count',
          'followers' => '$followers',
          'posting_rewrds' => '$posting_rewards',
          'curation_rewards' => '$curation_rewards',
          'vests' => '$vesting_shares',
        ]
      ],
      [
        '$sort' => [
          'date' => -1
        ]
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function miningAction() {
    $account = $this->dispatcher->getParam("account");
    $witness = Block30d::aggregate([
      [
        '$match' => [
          'witness' => $account,
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
          ],
        ]
      ],
      [
        '$project' => [
          'witness' => 1,
          '_ts' => 1,
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'blocks' => [
            '$sum' => 1
          ]
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    $pow = Pow::aggregate([
      [
        '$match' => [
          'work.input.worker_account' => $account,
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
          ],
        ]
      ],
      [
        '$project' => [
          'work.input.worker_account' => 1,
          '_ts' => 1,
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'blocks' => [
            '$sum' => 1
          ]
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    if(empty($pow)) {
      // Plottable doesn't play well when the first series is empty.
      $pow = array(array('_id' => ['doy' => 0,'year' => 0,'month' => 0,'week' => 0,'day' => 0], 'blocks' => 0));
    }
    echo json_encode(['pow' => $pow, 'witness' => $witness]);
  }

  public function votesAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Vote::aggregate([
      [
        '$match' => [
          '$or' => [
            ['voter' => $account],
            ['author' => $account],
          ],
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'votes' => [
            '$sum' => 1
          ],
          'incoming' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$author', $account]],
              1,
              0,
            ]],
          ],
          'outgoing' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$voter', $account]],
              1,
              0,
            ]],
          ],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function postsAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Comment::aggregate([
      [
        '$match' => [
          'author' => $account,
          'created' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$created'],
            'year' => ['$year' => '$created'],
            'month' => ['$month' => '$created'],
            'week' => ['$week' => '$created'],
            'day' => ['$dayOfMonth' => '$created']
          ],
          'posts' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$depth', 0]],
              1,
              0,
            ]],
          ],
          'replies' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$depth', 0]],
              0,
              1,
            ]],
          ],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function witnessAction() {
    $account = $this->dispatcher->getParam("account");
    $data = WitnessHistory::aggregate([
      [
        '$match' => [
          'owner' => $account
        ]
      ],
      [
        '$project' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$created'],
            'year' => ['$year' => '$created'],
            'month' => ['$month' => '$created'],
            'day' => ['$dayOfMonth' => '$created'],
          ],
          'votes' => '$votes'
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function curationAction() {
    $account = $this->dispatcher->getParam("account");
    $data = CurationReward::aggregate([
      [
        '$match' => [
          'curator' => $account,
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts'],
          ],
          'count' => ['$sum' => 1],
          'value' => ['$sum' => '$reward'],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }
  public function transfersAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Transfer::aggregate([
      [
        '$match' => [
          '$or' => [
            ['from' => $account],
            ['to' => $account],
          ],
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts'],
          ],
          'value' => ['$sum' => ['$cond' => [
            ['$eq' => ['$to', $account]],
            '$amount',
            ['$multiply' => ['$amount', -1]]
          ]]],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function contentvoteAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Vote::aggregate([
      [
        '$match' => [
          'voter' => $account,
        ]
      ],
      [
        '$sort' => [
          '_ts' => -1,
        ]
      ],
      [
        '$project' => [
          '_id' => ['$concat' => ['$author', '/', '$permlink']],
          'voter' => 1,
          'author' => 1,
          'permlink' => 1,
          'ts' => '$_ts',
          'time' => [
            '$dateToString' => [
              'format' => '%Y-%m-%d %H:%M:%S',
              'date' => '$_ts',
            ]
          ]
        ]
      ],
      [
        '$lookup' => [
          'from' => 'comment',
          'localField' => 'permlink',
          'foreignField' => 'permlink',
          'as' => 'content'
        ]
      ],
      [
        '$limit' => 10,
      ],
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }
  public function contentreblogAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Reblog::aggregate([
      [
        '$match' => [
          'account' => $account,
        ]
      ],
      [
        '$sort' => [
          '_ts' => -1,
        ]
      ],
      [
        '$project' => [
          '_id' => ['$concat' => ['$author', '/', '$permlink']],
          'account' => 1,
          'author' => 1,
          'permlink' => 1,
          'ts' => '$_ts',
          'time' => [
            '$dateToString' => [
              'format' => '%Y-%m-%d %H:%M:%S',
              'date' => '$_ts',
            ]
          ]
        ]
      ],
      [
        '$lookup' => [
          'from' => 'comment',
          'localField' => '_id',
          'foreignField' => '_id',
          'as' => 'content',
        ]
      ],
      [
        '$limit' => 10,
      ],
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }
}
