Infinity-Tile-View
==================

2 subclasses of UIScrollView which displays multi views in a grid and can allow scrolling infinitely for both directions.

This is my practice for my ideas that I got from UITableView model and Apple's sample "StreetScroller". It includes:

- A simple tile view which help displaying multi views into a grid of same size cells. It loads only the visible views to save memory.

- The infinity tile view has additional features:
  + The size of rows and columns can be different.
  + User can scroll infinitely.

Both views include 2 parts:
- A tile view subclassing of UIView will arrange the subviews (cells) into place.
- An UIScrollView subclassing detects the visible area and tells the tile view displaying cells.
You can use the tile view to arrang views without the UIScrollView.
The simple tile view and the Infinity tile view have a common job which is arranging views into grid. But the technique is different so I implemented 2 differents class. In theory, the simple tile view should run faster.

My idea is that each cell shows an UIView, so it's easy to customize the UI of the app.
Note that this is almost my pratice. Its job is only arranging the views. To use in a complete project, maybe you have to add more works, eg. interaction with user, animation ...

License: LGPL 3

 Created by Phạm Quang Dương
 Copyright © 2012 Runsytem.vn

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 3 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA