# CoreDataEntityFromCSV
Export the csv of sql table from phpMyAdmin panel and create all those entity and attribute into coredata xcdatamodelid file. 
This is just a poc concept I made to make the task easy of migrating the server table and entity into coredata file structure.
In CSV file make sure the first coulmn is name of table / Entity , second column the name of attribute / cloumn name and third one the Data type.
Currently varchar , int , date , timestamp would be automatically converted into respective swift Datatypes.



