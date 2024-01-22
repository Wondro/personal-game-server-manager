// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

//EDIT ONLY THESE VALUES
var mcCloudfrontUrl = 'https://d39iyb6zsdgay8.cloudfront.net' //mcCloudfrontUrl
var mcCognitoClientID = '2t17h81455m4j9gaesor5kcrd1' //mcCognitoClientID
var mcCognitoDomainName = 'd39iyb6zsdgay8.auth.us-east-2.amazoncognito.com' //mcCognitoDomainName
var mcCognitoPoolsId = 'us-east-2_t6x0n4JpS' //mcCognitoPoolsId
var API_URL = 'https://g14d3ebmja.execute-api.us-east-2.amazonaws.com/prod/'; //mcControlApiUrl

const query_string = "?mctagname=mcServerFinder&mctagvalue=mcServer"
var tagName = 'mcServerFinder'
var tagValue = 'mcServer'
var stackname = 'Valheim-Server'
//EDIT ONLY THESE VALUES

var aws_auth_config = {
  "aws_user_pools_id": mcCognitoPoolsId,
  "aws_user_pools_web_client_id": mcCognitoClientID,
  "oauth": {
      "domain": mcCognitoDomainName,
      "scope": [
          "openid",
          "aws.cognito.signin.user.admin"
      ],
      "redirectSignIn": mcCloudfrontUrl + '/signed_in.html',
      "redirectSignOut": mcCloudfrontUrl + '/logout.html',
      "responseType": "code"
  },
  "federationTarget": "COGNITO_USER_POOLS",
  "aws_cognito_username_attributes": ["EMAIL"],
  "aws_cognito_signup_attributes": [
      "EMAIL"
  ],
  "aws_cognito_mfa_configuration": "OFF",
  "aws_cognito_mfa_types": [
      "SMS"
  ],
  "aws_cognito_password_protection_settings": {
      "passwordPolicyMinLength": 8,
      "passwordPolicyCharacters": []
  },
  "aws_cognito_verification_mechanisms": [
      "EMAIL"
  ]
};
