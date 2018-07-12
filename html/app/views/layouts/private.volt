<div class="navbar navbar-inverse">
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
