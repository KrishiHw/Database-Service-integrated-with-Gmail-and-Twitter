import ballerina/http;
import ballerina/io;
import wso2/twitter;
import ballerina/config;
import ballerina/log;

endpoint twitter:Client twitter {
   clientId: config:getAsString("consumerKey"),
   clientSecret: config:getAsString("consumerSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret")
};


documentation {
   A service endpoint represents a listener.
}
endpoint http:Listener listener3 {
    port:4200
};

documentation {
   A service is a network-accessible API
   Advertised on '/hello', port comes from listener endpoint
}

 @http:ServiceConfig {
   basePath: "/twitter"
}
service<http:Service> helloTwitter bind listener3 {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/tweet/"
    }

    documentation {
       A resource is an invokable API method
       Accessible at '/hello/sayHello
       'caller' is the client invoking this resource 
       P{{caller}} Server Connector
       P{{request}} Request
    }

    sayHello (endpoint caller, http:Request request) {

        json req = check request.getJsonPayload();

        //Get value to be passed as the tweet
        string msg = req.Message.toString();
        
        try
        {
            twitter:Status st = check twitter->tweet(msg, "", "");
            io:println("You tweeted!");
        }
        catch(error er)
        {
            io:println(er.message);
            io:println("Tweet was not Sent.");
        }

    }
}