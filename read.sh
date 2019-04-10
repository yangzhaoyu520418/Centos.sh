
file_object = open('test.txt','rU')
try:
    for line in file_object:
         do_somthing_with(line)//line带"\n"
finally:
     file_object.close()