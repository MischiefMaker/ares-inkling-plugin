
To have hints viewable on the web profile, you need to make the following changes:

open ares/ares-webportal/app/templates/components/profile-custom-tabs.hbs and add the following line:

    <li><a data-toggle="tab" href="#systemhints">Gifts</a></li>

open ares/ares-webportal/app/templates/components/profile-custom.hbs and add the following lines:

    <div id="systemhints" class="tab-pane fade">
      <h2>Gifts & Abilities</h2>
      {{#each char.custom.gifts as |gift|}}
        <h3>{{gift.name}}</h3>
        <p>{{{ansi-format text=gift.desc}}}</p>
     {{else}}
        <p>This character has no powers.</p>
      {{/each}}
    </div>

Open aresmush/plugins/profile/custom_char_fields.rb and modify the get_fields_for_viewing:

    def self.get_fields_for_viewing(char, viewer)
    return {
            gifts: Gifts.get_gifts_for_web_viewing(char, viewer)
       }
    end

When finished, from the MUSH, type:

    load profile

then:

    website/deploy

Once the website has redeployed, the tab should appear on the profile.
