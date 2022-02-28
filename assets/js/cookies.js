import "vanilla-cookieconsent";
const cc = initCookieConsent();

document.body.classList.toggle('c_darkmode');

cc.run({
  current_lang: 'en',
  revision: 1,
  autoclear_cookies: true,
  page_scripts: true,
  mode: 'opt-in',
  delay: 0,
  auto_language: null,
  autorun: true,
  force_consent: false,
  hide_from_bots: false,
  remove_cookie_tables: false,
  cookie_name: 'cookieConsent',
  cookie_expiration: 30,

  gui_options: {
    consent_modal: {
      layout: 'cloud',
      position: 'bottom right',
      transition: 'slide',
      swap_buttons: false
    },
    settings_modal: {
      layout: 'bar',
      position: 'right',
      transition: 'slide'
    }
  },

  languages: {
    'en': {
      consent_modal: {
        title: 'We use cookies!',
        description: 'Hi, this website uses essential cookies to ensure its proper operation and tracking cookies to understand how you interact with it. The latter will be set only after consent. <button type="button" data-cc="c-settings" class="cc-link">Let me choose</button>',
        revision_message: '<br> Our terms have been updated. Please check your settings to see if you agree with the new terms.',
        primary_btn: {
          text: 'Accept all',
          role: 'accept_all'
        },
        secondary_btn: {
          text: 'Reject all',
          role: 'accept_necessary'
        }
      },
      settings_modal: {
        title: 'Cookie preferences',
        save_settings_btn: 'Save settings',
        accept_all_btn: 'Accept all',
        reject_all_btn: 'Reject all',
        close_btn_label: 'Close',
        cookie_table_headers: [
          { col1: 'Name' },
          { col2: 'Domain' },
          { col3: 'Expiration' },
          { col4: 'Description' }
        ],
        blocks: [
          {
            title: 'Cookie usage 📢',
            description: 'We use cookies to ensure the basic functionalities of the website and to enhance your online experience. You can choose for each category to opt-in/out whenever you want. For more details relative to cookies and other sensitive data, please read the full <a href="/policy" class="cc-link">privacy policy</a>.'
          }, {
            title: 'Strictly necessary cookies',
            description: 'These cookies are essential for the proper functioning of this website. Without these cookies, the website would not work properly',
            toggle: {
              value: 'necessary',
              enabled: true,
              readonly: true
            },
            cookie_table: [
              {
                col1: '_hergetto_key',
                col2: 'localhost',
                col3: '30 days',
                col4: 'Used to store the user\'s session'
              }
            ]
          }, {
            title: 'Performance and Analytics cookies',
            description: 'These cookies collect information about how you use the website, which pages you visited and which links you clicked on. All of the data is anonymized and cannot be used to identify you.',
            toggle: {
              value: 'analytics',
              enabled: false,
              readonly: false
            },
            cookie_table: [
              {
                col1: 'VISITOR_INFO1_LIVE',
                col2: 'youtube.com',
                col3: '6 months',
                col4: 'A cookie set by YouTube to measure bandwidth that determines whether the user gets the new or old player interface.'
              },
              {
                col1: 'YSC',
                col2: '.youtube.com',
                col3: 'session',
                col4: 'YSC cookie is set by Youtube and is used to track the views of embedded videos on Youtube pages.'
              },
              {
                col1: '^_ga',
                col2: 'google.com',
                col3: '2 years',
                col4: 'The _ga cookie, installed by Google Analytics, calculates visitor, session and campaign data and also keeps track of site usage for the site\'s analytics report. The cookie stores information anonymously and assigns a randomly generated number to recognize unique visitors.',
                is_regex: true
              },
              {
                col1: '_gid',
                col2: 'google.com',
                col3: '1 day',
                col4: 'Installed by Google Analytics, _gid cookie stores information on how visitors use a website, while also creating an analytics report of the website\'s performance. Some of the data that are collected include the number of visitors, their source, and the pages they visit anonymously.',
              }
            ]
          }, {
            title: 'More information',
            description: 'For any queries in relation to our policy on cookies and your choices, please <a class="cc-link" href="/about">contact us</a>.',
          }
        ]
      }
    }
  }
});
