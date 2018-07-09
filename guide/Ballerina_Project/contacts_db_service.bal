import ballerina/io;
import ballerina/time;
import ballerina/sql;
import ballerina/config;
import ballerina/mysql;
import ballerina/log;
import ballerina/http;

type Customer {
    int b_no;
    int c_id;
    string c_amount;
    string c_email;
    string c_dateCreated;
};

// Create SQL endpoint to MySQL database
endpoint mysql:Client customerDB {
    host: config:getAsString("DATABASE_HOST", default = "localhost"),
    port: config:getAsInt("DATABASE_PORT", default = 3306),
    name: config:getAsString("DATABASE_NAME", default = "CUSTOMER_RECORDS"),
    username: config:getAsString("DATABASE_USERNAME", default = "root"),
    password: config:getAsString("DATABASE_PASSWORD", default = "123"),
    dbOptions: { useSSL: false }
};

endpoint http:Listener listener {
    port: 9090
};

// Service for the customer data service
@http:ServiceConfig {
    basePath: "/records"
}
service<http:Service> CustomerData bind listener {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/customer/"
    }
    addCustomerBillDetails(endpoint httpConnection, http:Request request) {

        http:Response response;
        Customer customerData;

        // Extract the data from the request payload
        var payloadJson = check request.getJsonPayload();
        customerData = check <Customer>payloadJson;

        // Invoke addBill method to save data in the mysql database
        try
        {
            json ret = addBill(customerData.b_no,customerData.c_id, customerData.c_amount,customerData.c_dateCreated);
        }
        catch(error er)
        {
            io:println(er.message);
        }
    }

}

//Add customer billing record to database
function addBill(int BillNo,int CustomerId,string Amount, string DateCreated) returns (json){
    json updateStatus;
    string sqlString = "INSERT INTO CUSTOMER_BILLS VALUES (?,?,?,?)";

    // Insert data to SQL database by invoking update action
    var ret = customerDB->update(sqlString, BillNo, CustomerId, Amount, DateCreated);
    
    // Use match operator to check the validity of the result from database
    match ret {
        int updateRowCount => {
            updateStatus = { "Status": "Data Inserted Successfully" };
        }
        error err => {
            updateStatus = { "Status": "Data Not Inserted", "Error": err.message };
        }
    }
    return updateStatus;
}

//get email from database
function retrieveEmail(int CustID) returns (json) {

     json jsonReturnValue;
     string sqlString = "SELECT Email FROM CUSTOMERS WHERE CustomerID=?";

     // Retrieve email by invoking select action defined in ballerina sql client
     var ret = customerDB->select(sqlString, (),CustID);
     
     match ret {
         table dataTable => {
             // Convert the sql data table into JSON using type conversion
             jsonReturnValue = check <json>dataTable;
         }
         error err => {
             jsonReturnValue = { "Status": "Data Not Found", "Error": err.message };
         }
     }
     return jsonReturnValue;
}

//get amount from database
function retrieveAmount(int CustID) returns (json) {

     json jsonReturnValue;
     string sqlString = "SELECT Amount FROM CUSTOMER_BILLS CustomerID=?";

     // Retrieve amount by invoking select action defined in ballerina sql client
     var ret = customerDB->select(sqlString, (),CustID);

     match ret {
         table dataTable => {
             // Convert the sql data table into JSON using type conversion
             jsonReturnValue = check <json>dataTable;
         }
         error err => {
             jsonReturnValue = { "Status": "Data Not Found", "Error": err.message };
         }
     }
     return jsonReturnValue;
}
