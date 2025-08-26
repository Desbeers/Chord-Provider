//
//  File.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 25/08/2025.
//

import Foundation

let htmlPage: String = """
<!DOCTYPE html>
<html lang="en">
<head>
<title>**TITLE**</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
"""
+ style
+ """
</head>
<body>
<div id="container">
**HEADER**
**CHORDS**
<div id="grid">
**CONTENT**
</div>
</div>
</body>
</html>
"""
