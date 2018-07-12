<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">Navbar</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        {{ link_to(null, '<i class="fas fa-wrench"></i> Tools', 'class':'nav-link') }}
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Link</a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Dropdown</a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="#">Action</a>
          <a class="dropdown-item" href="#">Another action</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#">Something else here</a>
        </div>
      </li>
    </ul>
  </div>
</nav>


<div class="navbar navbar-expand-lg">
  <div class="navbar-inner">
    <div class="container" style="width: auto;">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      {{ link_to(null, 'class': 'brand', 'kPKI - Management')}}
      <div class="nav-collapse">
        <ul class="nav">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Certificate Management <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li>{{ link_to('certificates', ' List Certificates') }}</li>
              <li>--- Create new Certificates ---</li>
              <li>{{ link_to('create/server', ' Create Server Certificate') }}</li>
              <li>{{ link_to('create/client', ' Create Client Certificate') }}</li>
            </ul>
          </li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">User Management <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li>{{ link_to('users', ' User') }}</li>
              <li>{{ link_to('profiles', ' Profiles') }}</li>
              <li>{{ link_to('permissions', ' Permissions') }}</li>
            </ul>
          </li>
        </ul>
        <ul class="nav pull-right">
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">{{ auth.getName() }} <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li>{{ link_to('users/changePassword', 'Change Password') }}</li>
            </ul>
          </li>
          <li>{{ link_to(null, 'Tools') }}</li>
          <li>{{ link_to('session/logout', 'Logout') }}</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="container">
  {{ content() }}
</div>

<footer>
  <p>Made with love in Germany<br>
  © {{ date("Y") }} Kai Pazdzewicz</p>
</footer>
