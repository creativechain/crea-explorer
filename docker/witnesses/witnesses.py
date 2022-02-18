from datetime import datetime
from crea import Crea
from pymongo import MongoClient
from pprint import pprint
from time import gmtime, strftime
from apscheduler.schedulers.background import BackgroundScheduler
import collections
import time
import sys
import os

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

misses = {}

# Command to check how many blocks a witness has missed
def check_misses():
    global misses
    witnesses = stm.rpc.get_witnesses_by_vote('', 100)
    for witness in witnesses:
        owner = str(witness['owner'])
        # Check if we have a status on the current witness
        if owner in misses.keys():
            # Has the count increased?
            if witness['total_missed'] > misses[owner]:
                # Update the misses collection
                record = {
                  'date': datetime.now(),
                  'witness': owner,
                  'increase': witness['total_missed'] - misses[owner],
                  'total': witness['total_missed']
                }
                db.witness_misses.insert_one(record)
                # Update the misses in memory
                misses[owner] = witness['total_missed']
        else:
            misses.update({owner: witness['total_missed']})



def update_witnesses():
    now = datetime.now().date()

    scantime = datetime.now()
    users = stm.rpc.get_witnesses_by_vote('', 100)
    pprint("CREASCAN - Update Witnesses (" + str(len(users)) + " accounts)")
    db.witness.remove({})
    for user in users:
        # Convert to Numbers
        for key in ['virtual_last_update', 'virtual_position', 'virtual_scheduled_time', 'votes']:
            user[key] = float(user[key])
        # Save current state of account
        db.witness.update_one({'_id': user['owner']}, {'$set': user}, upsert=True)
        # Create our Snapshot dict
        snapshot = user.copy()
        _id = user['owner'] + '|' + now.strftime('%Y%m%d')
        snapshot.update_one({
          '_id': _id,
          'created': scantime
        })
        # Save Snapshot in Database
        db.witness_history.update_one({'_id': _id}, {'$set': snapshot}, upsert=True)

def run():
    update_witnesses()
    check_misses()

if __name__ == '__main__':
    # Start job immediately
    run()
    # Schedule it to run every 1 minute
    scheduler = BackgroundScheduler()
    scheduler.add_job(run, 'interval', seconds=30, id='run')
    scheduler.start()
    # Loop
    try:
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
