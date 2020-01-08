import argparse    # 1. argparseをインポート
from ete3 import Tree, TreeStyle
import pandas as pd

parser = argparse.ArgumentParser(description='系統樹と表の並び替え')   
parser.add_argument('-n', '--newick', help='newick file') 
parser.add_argument('-o1', '--outgroup1', help='set outgroup1')   
parser.add_argument('-o2', '--outgroup2', help='set outgroup2')  
args = parser.parse_args() 

NEWICK = args.newick
OUTG1 = args.outgroup1
OUTG2 = args.outgroup2

# 系統樹の読み込み
t = Tree(NEWICK , format= 0)
ancestor = t.get_common_ancestor(OUTG1,OUTG2)
t.set_outgroup( ancestor )
ts = TreeStyle()
ts.show_leaf_name = True
ts.show_branch_support = True
t.render(NEWICK+".png", w=600, units="mm",tree_style=ts)
t.write(format=0, outfile=NEWICK+".newick")
