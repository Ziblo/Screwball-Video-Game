{
  "spriteId": {
    "name": "sMovingPlatform",
    "path": "sprites/sMovingPlatform/sMovingPlatform.yy",
  },
  "solid": false,
  "visible": true,
  "spriteMaskId": null,
  "persistent": false,
  "parentObjectId": {
    "name": "oWall",
    "path": "objects/oWall/oWall.yy",
  },
  "physicsObject": false,
  "physicsSensor": false,
  "physicsShape": 1,
  "physicsGroup": 1,
  "physicsDensity": 0.5,
  "physicsRestitution": 0.1,
  "physicsLinearDamping": 0.1,
  "physicsAngularDamping": 0.1,
  "physicsFriction": 0.2,
  "physicsStartAwake": true,
  "physicsKinematic": false,
  "physicsShapePoints": [],
  "eventList": [
    {"isDnD":false,"eventNum":0,"eventType":3,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":0,"eventType":0,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
  ],
  "properties": [
    {"varType":5,"value":"noone","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"path","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":6,"value":"path_action_reverse","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[
        "path_action_stop",
        "path_action_restart",
        "path_action_continue",
        "path_action_reverse",
      ],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"end_action","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":3,"value":"True","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"absolute","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"1","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"path_speed","tags":[],"resourceType":"GMObjectProperty",},
  ],
  "overriddenProperties": [],
  "parent": {
    "name": "Solids",
    "path": "folders/Objects/Solids.yy",
  },
  "resourceVersion": "1.0",
  "name": "oMovingPlatform",
  "tags": [],
  "resourceType": "GMObject",
}