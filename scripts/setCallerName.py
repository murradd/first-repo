import csv
from freeswitch import *
 
def handler(session,args):
    caller = session.getVariable("caller") 
    csv_reader = csv.reader(open("outdir/file.csv","rb"))
    portfolio_list = []
    portfolio_list.extend(csv_reader)
    for data in portfolio_list:
        if (data[0] == caller): 
            session.execute("set","effective_caller_id_name="+data[1])
