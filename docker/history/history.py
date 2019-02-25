from datetime import datetime
from crea import Crea
from pymongo import MongoClient
from pprint import pprint
import collections
import time
import sys
import os
import re

from apscheduler.schedulers.background import BackgroundScheduler

stm = Crea(node=["https://" + os.environ['crearynode']], custom_chains={"CREA":
    {'chain_assets': [{'asset': 'CREA', 'id': 0, 'precision': 3, 'symbol': 'CREA'},
                      {'asset': 'VESTS', 'id': 1, 'precision': 6, 'symbol': 'VESTS'}],
     'chain_id': '0000000000000000000000000000000000000000000000000000000000000000',
     'min_version': '0.0.0',
     'prefix': 'CREA'}
    }
)

mongo = MongoClient("mongodb://mongo")
db = mongo.crearydb

mvest_per_account = {}

def load_accounts():
    pprint("CrearyDB - Loading mvest per account")
    for account in db.account.find():
        if "name" in account.keys():
            mvest_per_account.update({account['name']: account['vesting_shares']})

def update_fund_history():
    pprint("[CREASCAN] - Update Fund History")

    fund = stm.rpc.get_reward_fund('post')
    for key in ['recent_claims', 'content_constant']:
        fund[key] = float(fund[key])
    for key in ['reward_balance']:
        fund[key] = float(fund[key].split()[0])
    for key in ['last_update']:
        fund[key] = datetime.strptime(fund[key], "%Y-%m-%dT%H:%M:%S")

    db.funds_history.insert(fund)

def update_props_history():
    pprint("[CREASCAN] - Update Global Properties")

    props = stm.rpc.get_dynamic_global_properties()

    for key in ['recent_slots_filled', 'total_reward_shares2']:
        props[key] = float(props[key])
    for key in ['confidential_supply', 'current_supply', 'total_reward_fund_crea', 'total_vesting_fund_crea', 'total_vesting_shares']:
        props[key] = float(props[key].split()[0])
    for key in ['time']:
        props[key] = datetime.strptime(props[key], "%Y-%m-%dT%H:%M:%S")

    #floor($return['total_vesting_fund_crea'] / $return['total_vesting_shares'] * 1000000 * 1000) / 1000;

    props['crea_per_mvests'] = props['total_vesting_fund_crea'] / props['total_vesting_shares'] * 1000000

    db.status.update({
      '_id': 'crea_per_mvests'
    }, {
      '$set': {
        '_id': 'crea_per_mvests',
        'value': props['crea_per_mvests']
      }
    }, upsert=True)

    db.status.update({
      '_id': 'props'
    }, {
      '$set': {
        '_id': 'props',
        'props': props
      }
    }, upsert=True)

    db.props_history.insert(props)

def update_tx_history():
    pprint("[CREASCAN] - Update Transaction History")
    now = datetime.now().date()

    today = datetime.combine(now, datetime.min.time())
    yesterday = today - timedelta(1)

    # Determine tx per day
    query = {
      '_ts': {
        '$gte': today,
        '$lte': today + timedelta(1)
      }
    }
    count = db.block_30d.count(query)

    pprint(count)

    pprint(now)
    pprint(today)
    pprint(yesterday)



def update_history():

    update_fund_history()
    update_props_history()
    # update_tx_history()
    # sys.stdout.flush()

    # Load all accounts
    users = stm.rpc.lookup_accounts(-1, 1000)
    more = True
    while more:
        newUsers = stm.rpc.lookup_accounts(users[-1], 1000)
        if len(newUsers) < 1000:
            more = False
        users = users + newUsers

    # Set dates
    now = datetime.now().date()
    today = datetime.combine(now, datetime.min.time())

    pprint("[CREASCAN] - Update History (" + str(len(users)) + " accounts)")
    # Snapshot User Count
    db.statistics.update({
      'key': 'users',
      'date': today,
    }, {
      'key': 'users',
      'date': today,
      'value': len(users)
    }, upsert=True)
    sys.stdout.flush()

    # Update history on accounts
    for user in users:
        # Load State
        state = stm.rpc.get_accounts([user])
        # Get Account Data
        account = collections.OrderedDict(sorted(state[0].items()))
        # Get followers
        account['followers'] = []
        account['followers_mvest'] = 0
        followers_results = stm.rpc.get_followers({"account": user, "start": "", "type": "blog", "limit": 100}, api="follow")['followers']
        while followers_results:
          last_account = ""
          for follower in followers_results:
            last_account = follower['follower']
            if 'blog' in follower['what'] or 'posts' in follower['what']:
              account['followers'].append(follower['follower'])
              if follower['follower'] in mvest_per_account.keys():
                account['followers_mvest'] += float(mvest_per_account[follower['follower']])
          followers_results = stm.rpc.get_followers({"account": user, "start": last_account, "type": "blog", "limit": 100}, api="follow")['followers'][1:]
        # Get following
        account['following'] = []
        following_results = stm.rpc.get_following({"account": user, "start": -1, "type": "blog", "limit": 100}, api="follow")['following']
        while following_results:
          last_account = ""
          for following in following_results:
            last_account = following['following']
            if 'blog' in following['what'] or 'posts' in following['what']:
              account['following'].append(following['following'])
          following_results = stm.rpc.get_following({"account": user, "start": last_account, "type": "blog", "limit": 100}, api="follow")['following'][1:]
        # Convert to Numbers
        account['proxy_witness'] = sum(float(i) for i in account['proxied_vsf_votes']) / 1000000
        for key in ['reputation', 'to_withdraw']:
            account[key] = float(account[key])
        for key in ['balance', 'savings_balance', 'vesting_balance', 'vesting_shares', 'vesting_withdraw_rate']:
            account[key] = float(account[key].split()[0])
        # Convert to Date
        for key in ['created','last_account_recovery','last_account_update', 'last_owner_update','last_post','last_root_post','last_vote_time','next_vesting_withdrawal']:
            account[key] = datetime.strptime(account[key], "%Y-%m-%dT%H:%M:%S")
        # Combine Savings + Balance
        account['total_balance'] = account['balance'] + account['savings_balance']
        # Update our current info about the account
        mvest_per_account.update({account['name']: account['vesting_shares']})
        # Save current state of account
        account['scanned'] = datetime.now()
        db.account.update({'_id': user}, account, upsert=True)
        # Create our Snapshot dict
        wanted_keys = ['name', 'proxy_witness', 'activity_shares', 'average_bandwidth', 'savings_balance', 'balance', 'comment_count', 'curation_rewards', 'lifetime_vote_count', 'next_vesting_withdrawal', 'reputation', 'post_bandwidth', 'post_count', 'posting_rewards', 'to_withdraw', 'vesting_balance', 'vesting_shares', 'vesting_withdraw_rate', 'voting_power', 'withdraw_routes', 'withdrawn', 'witnesses_voted_for']
        snapshot = dict((k, account[k]) for k in wanted_keys if k in account)
        snapshot.update({
          'account': user,
          'date': today,
          'followers': len(account['followers']),
          'following': len(account['following']),
        })
        # Save Snapshot in Database
        db.account_history.update({
          'account': user,
          'date': today
        }, snapshot, upsert=True)

def update_stats():
  pprint("updating stats");
  # Calculate Transactions
  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 28800 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '24h',
        'tx': {
          '$sum': 1
        }
      }
    }
  ])
  data = list(results)[0]['tx']
  db.status.update({'_id': 'transactions-24h'}, {'$set': {'data' : data}}, upsert=True)
  now = datetime.now().date()
  today = datetime.combine(now, datetime.min.time())
  db.tx_history.update({
    'timeframe': '24h',
    'date': today
  }, {'$set': {'data': data}}, upsert=True)

  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 1200 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '1h',
        'tx': {
          '$sum': 1
        }
      }
    }
  ])
  try:
    db.status.update({'_id': 'transactions-1h'}, {'$set': {'data' : list(results)[0]['tx']}}, upsert=True)
  except IndexError:
    db.status.update({'_id': 'transactions-1h'}, {'$set': {'data' : 0}}, upsert=True)

  # Calculate Operations
  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 28800 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '24h',
        'tx': {
          '$sum': {
            '$size': '$transactions.operations'
          }
        }
      }
    }
  ])
  data = list(results)[0]['tx']
  db.status.update({'_id': 'operations-24h'}, {'$set': {'data' : data}}, upsert=True)
  now = datetime.now().date()
  today = datetime.combine(now, datetime.min.time())
  db.op_history.update({
    'timeframe': '24h',
    'date': today
  }, {'$set': {'data': data}}, upsert=True)

  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 1200 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '1h',
        'tx': {
          '$sum': {
            '$size': '$transactions.operations'
          }
        }
      }
    }
  ])
  try:
    db.status.update({'_id': 'operations-1h'}, {'$set': {'data' : list(results)[0]['tx']}}, upsert=True)
  except:
    db.status.update({'_id': 'operations-1h'}, {'$set': {'data' : 0}}, upsert=True)

def update_clients():
  try:
    pprint("updating clients");
    start = datetime.today() - timedelta(days=90)
    end = datetime.today()
    regx = re.compile("([\w-]+\/[\w.]+)", re.IGNORECASE)
    results = db.comment.aggregate([
      {
        '$match': {
          'created': {
            '$gte': start,
            '$lte': end,
          },
          'json_metadata.app': {
            '$type': 'string',
            '$regex': regx,
          }
        }
      },
      {
        '$project': {
          'created': '$created',
          'parts': {
            '$split': ['$json_metadata.app', '/']
          },
          'reward': {
            '$add': ['$total_payout_value', '$pending_payout_value', '$total_pending_payout_value']
          }
        }
      },
      {
        '$group': {
          '_id': {
            'client': {'$arrayElemAt': ['$parts', 0]},
            'doy': {'$dayOfYear': '$created'},
            'year': {'$year': '$created'},
            'month': {'$month': '$created'},
            'day': {'$dayOfMonth': '$created'},
            'dow': {'$dayOfWeek': '$created'},
          },
          'reward': {'$sum': '$reward'},
          'value': {'$sum': 1}
        }
      },
      {
        '$sort': {
          '_id.year': 1,
          '_id.doy': 1,
          'value': -1,
        }
      },
      {
        '$group': {
          '_id': {
            'doy': '$_id.doy',
            'year': '$_id.year',
            'month': '$_id.month',
            'day': '$_id.day',
            'dow': '$_id.dow',
          },
          'clients': {
            '$push': {
              'client': '$_id.client',
              'count': '$value',
              'reward': '$reward'
            }
          },
          'reward' : {
            '$sum': '$reward'
          },
          'total': {
            '$sum': '$value'
          }
        }
      },
      {
        '$sort': {
          '_id.year': -1,
          '_id.doy': -1
        }
      },
    ])
    pprint("complete")
    sys.stdout.flush()
    data = list(results)
    db.status.update({'_id': 'clients-snapshot'}, {'$set': {'data' : data}}, upsert=True)
    now = datetime.now().date()
    today = datetime.combine(now, datetime.min.time())
    db.clients_history.update({
      'date': today
    }, {'$set': {'data': data}}, upsert=True)
    pass
  except Exception as e:
    pass


if __name__ == '__main__':
    pprint("starting");
    # Load all account data into memory

    # Start job immediately
    update_clients()
    update_props_history()
    load_accounts()
    update_stats()
    update_history()
    sys.stdout.flush()

    # Schedule it to run every 6 hours
    scheduler = BackgroundScheduler()
    scheduler.add_job(update_history, 'interval', hours=6, id='update_history')
    scheduler.add_job(update_clients, 'interval', hours=1, id='update_clients')
    scheduler.add_job(update_stats, 'interval', minutes=5, id='update_stats')
    scheduler.start()
    # Loop
    try:
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
