<h1>Database-Service-integrated-with-Gmail-and-Twitter</h1>

Delays which occur in the traditional postal service is a common problem consumers/customers have to deal with when paying monthly bills (telephone bill etc). The proposed solution aims to provide customers with a more efficient system of notification to overcome the such delays.The proposed solution is developed for a telephone service provider. The functionalities of the proposed system is as follows,
<ul>
<li>Send emails to customers with their monthly billing information as soon as the details are updated in the system database</li>
<li>Tweet information about offers,promotions etc offered by the service provider</li>
</ul>

<h2>Installing</h2>
Download Ballerina here : https://ballerina.io/downloads/

<h2>Running</h2>
Enter the following command to run the project,

`ballerina run Ballerina_project`

This will provide you with a menu which perform the actions related to the selected option as shown belown.

![screenshot from 2018-07-09 21-37-42](https://user-images.githubusercontent.com/28100434/42462369-b59d50b0-83c0-11e8-80a2-d87268a255ac.png)

If the user selects option 1, it will prompt the user to enter billing information. The values entered will be added to the database and a gmail is sent to the relavent customer with the billing information.

![screenshot from 2018-07-09 21-38-32](https://user-images.githubusercontent.com/28100434/42462488-0c242350-83c1-11e8-925d-633fcd5aa7c8.png)

If the user selects option 2, it will prompt the user to enter a message( regarding offers, promotions etc by the company) to be tweeted.

![screenshot from 2018-07-09 21-40-16](https://user-images.githubusercontent.com/28100434/42462579-5004f130-83c1-11e8-8e65-2ac1b2cd50b1.png)

