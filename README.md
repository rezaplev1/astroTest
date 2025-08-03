# astroTest

## Requirements

- SwiftUI
- Xcode 16.4
- min iOS 13

## Foldering


```
MyApp/
├── Services/
│   ├── APIClient.swift        
├── Models/
│   └── LoginModel.swift
├── CoreData/
│   └── LoginModel.swift
├── Utilities/
│   └── Helpers.swift
│   └── Extensions/
│       ├── String+Extension.swift
│       ├── UIColor+Extension.swift
│       └── View+CornerRadius.swift
├── Modeule/
│   └── UserList/
│       └── ViewModel/
│       │   └── UserListViewModel.swift
│       └── ViewController/
│       │   └── UserListViewController.swift
│       └── View/
│           └── UserListView.swift
```



## Brancing

    main → untuk rilis final
    •    develop → untuk integrasi fitur
    •    feature/<sprint>/<Jira Number>* → untuk fitur baru
    •    release/* → untuk persiapan rilis
    •    hotfix/* → untuk perbaikan cepat di production
