LAB=$1
cd $LAB
export $(xargs < var.txt)
