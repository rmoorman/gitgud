/**
 * @flow
 * @relayHash 7bb499bf780b764ec31d9f892245fea2
 */

/* eslint-disable */

'use strict';

/*::
import type { ConcreteRequest } from 'relay-runtime';
export type SearchQueryVariables = {|
  input: string
|};
export type SearchQueryResponse = {|
  +search: ?{|
    +edges: ?$ReadOnlyArray<?{|
      +node: ?({|
        +__typename: "User",
        +id: string,
        +login: string,
        +name: ?string,
        +url: string,
      |} | {|
        +__typename: "Repo",
        +owner: {|
          +login: string
        |},
      |} | {|
        // This will never be '%other', but we need some
        // value in case none of the concrete values match.
        +__typename: "%other"
      |})
    |}>
  |}
|};
export type SearchQuery = {|
  variables: SearchQueryVariables,
  response: SearchQueryResponse,
|};
*/


/*
query SearchQuery(
  $input: String!
) {
  search(all: $input, first: 10) {
    edges {
      node {
        __typename
        ... on User {
          id
          login
          name
          url
        }
        ... on Repo {
          id
          name
          owner {
            login
            id
          }
          url
        }
        ... on Node {
          id
        }
      }
    }
  }
}
*/

const node/*: ConcreteRequest*/ = (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "String!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "all",
    "variableName": "input",
    "type": "String"
  },
  {
    "kind": "Literal",
    "name": "first",
    "value": 10,
    "type": "Int"
  }
],
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "login",
  "args": null,
  "storageKey": null
},
v5 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "name",
  "args": null,
  "storageKey": null
},
v6 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "url",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "operationKind": "query",
  "name": "SearchQuery",
  "id": null,
  "text": "query SearchQuery(\n  $input: String!\n) {\n  search(all: $input, first: 10) {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          login\n          name\n          url\n        }\n        ... on Repo {\n          id\n          name\n          owner {\n            login\n            id\n          }\n          url\n        }\n        ... on Node {\n          id\n        }\n      }\n    }\n  }\n}\n",
  "metadata": {},
  "fragment": {
    "kind": "Fragment",
    "name": "SearchQuery",
    "type": "RootQueryType",
    "metadata": null,
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "search",
        "storageKey": null,
        "args": v1,
        "concreteType": "SearchResultConnection",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "edges",
            "storageKey": null,
            "args": null,
            "concreteType": "SearchResultEdge",
            "plural": true,
            "selections": [
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "node",
                "storageKey": null,
                "args": null,
                "concreteType": null,
                "plural": false,
                "selections": [
                  v2,
                  {
                    "kind": "InlineFragment",
                    "type": "User",
                    "selections": [
                      v3,
                      v4,
                      v5,
                      v6
                    ]
                  },
                  {
                    "kind": "InlineFragment",
                    "type": "Repo",
                    "selections": [
                      v3,
                      v5,
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "owner",
                        "storageKey": null,
                        "args": null,
                        "concreteType": "User",
                        "plural": false,
                        "selections": [
                          v4
                        ]
                      },
                      v6
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "SearchQuery",
    "argumentDefinitions": v0,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "search",
        "storageKey": null,
        "args": v1,
        "concreteType": "SearchResultConnection",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "edges",
            "storageKey": null,
            "args": null,
            "concreteType": "SearchResultEdge",
            "plural": true,
            "selections": [
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "node",
                "storageKey": null,
                "args": null,
                "concreteType": null,
                "plural": false,
                "selections": [
                  v2,
                  v3,
                  {
                    "kind": "InlineFragment",
                    "type": "User",
                    "selections": [
                      v4,
                      v5,
                      v6
                    ]
                  },
                  {
                    "kind": "InlineFragment",
                    "type": "Repo",
                    "selections": [
                      v5,
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "owner",
                        "storageKey": null,
                        "args": null,
                        "concreteType": "User",
                        "plural": false,
                        "selections": [
                          v4,
                          v3
                        ]
                      },
                      v6
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
};
})();
// prettier-ignore
(node/*: any*/).hash = '66db58b7acf71eb8df800f26f7b3708e';
module.exports = node;
