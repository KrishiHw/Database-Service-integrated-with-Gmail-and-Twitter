import ballerina/io;
import ballerina/time;

public string ex_email;
public string ex_amount;

//endpoints for services

endpoint http:Client dbClient{
    url: "http://localhost:9090"
};

endpoint http:Client emailClient {
      url: "http://localhost:8080"
};

endpoint http:Client twitterClient {
      url: "http://localhost:4200"
};


function main(string... args) {
    int c = 0;
    while ( c != 3) {
        // print options menu to choose from
        menuOptions();

        // read user's choice
        string choice = io:readln("Enter choice 1 - 3: ");
        c = check <int>choice;

        //Send email
        if (c == 1) {
            io:println("-------------------------------------------------------------------------");
            string b_no = io:readln("Enter BillNo: ");
            int bill_no = check <int>b_no;
            string cid = io:readln("Enter CustomerID: ");
            int c_id = check <int>cid;
            string camount = io:readln("Enter Bill Amount: ");
            time:Time time = time:currentTime();
            string ctime = time.format("yyyy-MM-dd");
        
            try
            {
                addBillDetails(bill_no,c_id,camount,ctime);
                sendEmail(c_id);
                menuOptions();
            }
            catch(error er)
            {
                io:println(er.message);
            }
        }

        //Send Tweet
        if (c == 2) 
        {
            io:println("-------------------------------------------------------------------------");
            string msg = io:readln("Enter Tweet: ");
            http:Response response = check twitterClient->post("/twitter/tweet",());
            
            try
            {
                sendTweet(msg);
                menuOptions();
            }
            catch(error er)
            {
                io:println(er.message);
            }
        }

        if (c == 3) {
            break;
        } 
    }     
}

//Menu Options List
function menuOptions()
{
    io:println("-------------------------------------------------------------------------");
        io:println("******************************** M E N U *********************************");
        io:println("1. Add Bill ");
        io:println("2. Tweet Offers,Promotions ");
        io:println("3. Exit ");
}

//Invoke database connectivity: add bill details of customers
function addBillDetails(int bill_no,int c_id,string camount,string ctime)
{
        http:Request req = new;

        // Set the JSON payload to the message to be sent to the endpoint.
        json jsonMsg = { BillNo: bill_no, CustomerID: c_id, Amount: camount, DateCreated: ctime };
        req.setJsonPayload(jsonMsg);

        //invoke 
        var response = emailClient->post("/records/customer/", req);

        
}

//Invoke email connectivity: send email including bill details to customers
function sendEmail(int c_id)
{
        http:Request req = new;
        
        //set formatted string values
        ex_email= extractEmail(c_id);
        ex_amount=  extractAmount(c_id);
        io:print(ex_email);

        // Set the JSON payload to the message to be sent to the endpoint.
        json jsonMsg = { Email: ex_email, Amount: ex_amount };
        req.setJsonPayload(jsonMsg);

        //invoke
        var response = emailClient->post("/email/send/", req);
        
}

//Invoke twitter connectivity: tweet about promotions,offers etc
function sendTweet(string msg)
{
        http:Request req = new;

        // Set the JSON payload to the message to be sent to the endpoint.
        json jsonMsg = { Message: msg };
        req.setJsonPayload(jsonMsg);

        //invoke
        var response = twitterClient->post("/twitter/tweet/", req);
        
}

//formatting returned string values
function extractAmount(int c_id) returns (string)
{
        string result=(retrieveAmount(c_id).toString());
        string[] partition1 = result.split(":");
        string part1 = partition1[1];
        string[] partition2 = part1.split("}");
        string part2 = partition2[0];
        string[] partition3 = part2.split("");
        string part3 = (partition3[1])+(partition3[2])+(partition3[3]);
        return part3;
}

//formatting returned string values
function extractEmail(int c_id) returns (string)
{
        string name=(retrieveEmail(c_id).toString());
        string result=(retrieveEmail(c_id).toString());
        string[] partition1 = result.split(":");
        string part1 = partition1[1];
        string[] partition2 = part1.split("}");
        string part2 = partition2[0];
        string part3=part2.substring(1, part2.length()-1);
        return part3;
}

