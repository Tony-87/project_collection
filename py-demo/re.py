import cgi
def main(): 
    print "Content-type: text/html\n"
    form = cgi.FieldStorage()
    if form.has_key("ServiceCode") and form["ServiceCode"].value != "":
        print "<h1> Hello",form["ServiceCode"].value,"</h1>" 
    else:   
        print "<h1> Error! Please enter first name.</h1>" 
main()