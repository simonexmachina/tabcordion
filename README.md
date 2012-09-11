# Bootstrap Tabcordion

First it's tabs, now it's an accordion - it's a **TABCORDION**!

A simple jQuery plugin that transforms a set of Bootstrap tabs into a Bootstrap accordion. It can be configured to perform this transformation based on the size of the container or viewport to provide responsive awesomeness to your buzzword-rich UI.

## Usage

### Using Bootstrap-Style Data-API

Coming soon!

### From JavaScript

    $('.tabcordion').tabcordion()

### Markup

	<div class="tabcordion">
	  <ul class="nav nav-tabs">
	    <li class="active"><a data-target=".home">Home</a></li>
	    <li><a data-target=".profile">Profile</a></li>
	    <li><a data-target=".messages">Messages</a></li>
	    <li><a data-target=".settings">Settings</a></li>
	  </ul>
	  <div class="tab-content">
	    <div class="home active in">
	      <h3>Home</h3>
	      <p>Rhoncus magna nec enim, et proin aliquet mid, porta magnis.</p>
	    </div>
	    <div class="profile">
	      <h3>Profile</h3>
	      <p>Odio mattis, non ut! Porttitor nunc phasellus cras elementum.</p>
	    </div>
	    <div class="messages">
	      <h3>Messages</h3>
	      <p>Enim hac tristique elementum, nec rhoncus porttitor sagittis cum.</p>
	    </div>
	    <div class="settings">
	      <h4>Settings</h4>
	      <p>Arcu auctor, porttitor tincidunt, aliquam ut ut, placerat porta pulvinar dictumst?</p>
	    </div>
	  </div>
	</div>