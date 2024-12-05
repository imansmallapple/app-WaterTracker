# Water Tracker
## Introduction

Water Tracker shows a simple demo of in-app communication on an `OpenHarmony` device.

![image](https://github.com/user-attachments/assets/c6b914e2-04c6-4726-8f46-2904d44f9cf6)

### Table of contents
 [Functionaility](#functionaility)  
 [General Process](#general-process)

## Functionaility
    •  Create a simple water tracking app. Enable the possibility of changing the default values within the app.
    •  Apart from being a tracking app, this project aims to show how to access persistance storage and how to perfom in-app communication.

## General Process
This part introduces the general process of the application development  
1. [Logic and functionailities](#logic-and-functionailities)
2. [Checking and testing](#checking-and-testing)
    
### Logic and functionailities
- The basic logic of the app is as follows:
  -  Upon launch, see if there is saved data within the built-in database (called `Preferences`)
	-  Propagate the saved data through the app
  -  When the user logs in a glass of water, propagate the data and save it to preferences

>**Using data persistance - Preferences**

- Within your business logic:
	initialize data preferences and check if there is any data stored.
	
	When calling getPreferences, we have to provide a name for the storage we'll be using. 
	Inside, data_preferences is structured as a <key,value> pair.

```typescript
import data_preferences from '@ohos.data.preferences';
  (...)
private dataPreferences: data_preferences.Preferences = null;

constructor(context: Context, storage: LocalStorage) {
    data_preferences.getPreferences(context, "preferencesName")
        .then((pref) => {
	    this.dataPreferences = pref;
	    this.preparePersistence();
        })
}
```
> **Note**  
> The `context` above is of `UIAbility.context` type

- Once the dataPreferences variable has been initialized, you can get the stored values. 
- The defaultValue is the value that will be used if nothing was previously saved.


```typescript
this.dataPreferences.get("keyName", "defaultValue").then((value) => {
    console.log("Loaded data = " + value);
});

```

> **Note**  
> Both saving and loading from `Preferences` is asynchronous.

```typescript
this.dataPreferences.put("keyName", "new value")
    .then(() => {
        this.dataPreferences.flush();
    });
```

- After putting new values into preferences, call `flush()` which will save your data.

>**Using data propagation - LocalStorage**

- To communicate between business logic and the UI, we need to use a data propagation tool. Here we're using LocalStorage.

- Within your business logic

Declare and initialize an instance of LocalStorage. We've done so within the `onCreate()` method of our Ability

```typescript
private storage : LocalStorage;

onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.storage = new LocalStorage();
}

```

- Create a variable that will serve as a link between business logic and UI

```typescript
this.storage.setOrCreate("linkName", value);
```

- To read the data call
```typescript
this.storage.get("linkName);
```

- Within the UI
Declare the storage, and mark it in the @Entry to your view.
Declare and initialize a variable that will link to the variable created in business logic.

```typescript
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct Index {
    @LocalStorageLink('linkName') private myVariable: string = "default value";
```

Once that is done, whenever `myVariable` is reassigned, the changes will be propagated to LocalStorage.

### Checking and Testing
- Since some actions in the app are asynchronous, using console logs was the preferred verification method.
  All functionalities can be tested on the `Previewer` or on an `Emulator`.
