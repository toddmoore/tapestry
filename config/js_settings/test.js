window.LiveWeb = {};
window.LiveWeb.Config = {
  xmpp: {
    boshUrls: [ 'http://test.com/bosh' ],
    domain:   'test.com',
    resource: 'web',
    mucHost:  'conference.test.com'
  },
  facebook: {
    appId: '289459021080031' // fb account: playup.web.test+1@gmail.com - playup123
  }
};

if (typeof(window.console) == 'undefined') {
  window.console = {
    log: function() {}
  };
}

window._gaq = [];
