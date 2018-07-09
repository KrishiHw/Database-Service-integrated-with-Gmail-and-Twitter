 import ballerina/http;
 import ballerina/io;
 import wso2/gmail;
 import ballerina/config;

 endpoint gmail:Client gmailEP {
     clientConfig:{
         auth:{
             accessToken:config:getAsString("accessToken"),
             clientId:config:getAsString("clientId"),
             clientSecret:config:getAsString("clientSecret"),
             refreshToken:config:getAsString("refreshToken")
         }
     }
};

documentation {
//    A service endpoint represents a listener.
}

endpoint http:Listener listener2 {
     port:8080
};

documentation {
//    A service is a network-accessible API
//    Advertised on '/hello', port comes from listener endpoint
}

@http:ServiceConfig {
    basePath: "/email"
}
service<http:Service> helloGmail bind listener2 {

     @http:ResourceConfig {
     methods: ["POST"],
     path: "/send"
     }

     sayHello (endpoint caller, http:Request request) {
        
         gmail:MessageRequest messageRequest;
         messageRequest.recipient = ex_email;
         messageRequest.sender = "abc@gmail.com";
         messageRequest.cc = "";
         messageRequest.subject = "Srilanka Telephone Service Provider: Monthly Payment";

         string body = "Dear Valued Customer,"+("\n")+("This is to inform you that your payment for this month is Rs.")+
                        (ex_amount)+("Thank you for your support")+("\n")+("SriLanka Telephone Service Provider");

         messageRequest.messageBody = body;

         //Set the content type of the mail as TEXT_PLAIN or TEXT_HTML.
        messageRequest.contentType = gmail:TEXT_PLAIN;
         
         //Send email
         try
         {
            var sendMessageResponse = gmailEP -> sendMessage("assignmentskdu@gmail.com", messageRequest); 
            io:println("Email sent successfully!");
         }
         catch(error err)
         {
            io:println(err.message);
            io:print("Email not sent");
         }
     }
}


