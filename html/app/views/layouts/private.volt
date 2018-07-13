<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">kPKI - Management</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item">
        {{ link_to(null, 'Tools', 'class':'nav-link') }}
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Certificate Management <b class="caret"></a></b>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          {{ link_to('certificate/index', 'Show Certificates', 'class':'dropdown-item') }}
          {{ link_to('certificate/search', 'Search Certificates', 'class':'dropdown-item') }}
          <div class="dropdown-divider"></div>
          {{ link_to('certificate/create', 'Create Certificate', 'class':'dropdown-item') }}
          {{ link_to('certificate/revoke', 'Revoke Certificate', 'class':'dropdown-item') }}
        </div>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{{ auth.getName() }} <b class="caret"></a></b>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          {{ link_to('users/changePassword', 'Change Password', 'class':'dropdown-item') }}
          <div class="dropdown-divider"></div>
          {{ link_to('users', ' User Management', 'class':'dropdown-item') }}
          {{ link_to('profiles', ' Profiles Management', 'class':'dropdown-item') }}
          {{ link_to('permissions', ' Permissions Management', 'class':'dropdown-item') }}
          <div class="dropdown-divider"></div>
          {{ link_to('session/logout', 'Logout', 'class':'dropdown-item') }}
        </div>
      </li>
    </ul>
  </div>
</nav>
<div class="container">
  {{ content() }}
</div>
<footer>
  <p>Made with <span class="red"><3</span> in Germany<br>
  © {{ date("Y") }} Kai Pazdzewicz | <a href="https://gitlab.fastnameserver.eu/root/kpki" target="_blank">GitLab</a> | <a href="https://gitlab.fastnameserver.eu/root/kpki/blob/master/License.md" target="_blank">BSD-3 License</a></p>
</footer>
