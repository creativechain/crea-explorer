<?php
namespace CrearyDB\Models;

class BenefactorReward extends Document
{
  public function getSource(){ return "benefactor_reward"; }

  public static function getDatedByPlatform() {
    return BenefactorReward::agg([
      ['$sort' => [
        '_ts' => -1
      ]],
      ['$group' => [
        '_id' => [
          'benefactor' => '$benefactor',
          'doy' => ['$dayOfYear' => '$_ts'],
          'year' => ['$year' => '$_ts'],
          'month' => ['$month' => '$_ts'],
          'day' => ['$dayOfMonth' => '$_ts'],
          'dow' => ['$dayOfWeek' => '$_ts'],
        ],
        'cbd_reward' => ['$sum' => '$cbd_reward'],
        'crea_reward' => ['$sum' => '$crea_reward'],
        'cgy_reward' => ['$sum' => '$cgy_reward'],
        'count' => ['$sum' => 1]
      ]],
      ['$group' => [
        '_id' => [
          'doy' => '$_id.doy',
          'year' => '$_id.year',
          'month' => '$_id.month',
          'day' => '$_id.day',
          'dow' => '$_id.dow',
        ],
        'benefactors' => [
          '$push' => [
            'benefactor' => '$_id.benefactor',
            'count' => '$count',
            'cbd_reward' => '$cbd_reward',
            'crea_reward' => '$crea_reward',
            'cgy_reward' => '$cgy_reward',
          ]
        ],
        'cbd_reward'  => [ '$sum' => '$cbd_reward' ],
        'crea_reward'  => [ '$sum' => '$crea_reward' ],
        'cgy_reward'  => [ '$sum' => '$cgy_reward' ],
        'total' => [
          '$sum' => '$count'
        ]
      ]],
      ['$sort' => [
        '_id.year' => -1,
        '_id.doy' => -1,
        'reward' => -1
      ]],
      ['$limit' => 30]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
  }
}
