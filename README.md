## Crawler setup

When you are running the vagrant for the first time.  
```
vagrant up --provision
```  

Add a http agent name
```
vim src/source/nutch/conf/nutch-site.xml  
```
Add the appropriate value to the property http.agent.name  

Login into the machine and run:  
```
cd /install_pkgs
sudo ./build.sh
```

## Updating your crawler  

Update your crawler schemas with new ones with  
```
sudo ./update.sh
```
