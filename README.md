# Web Component

These steps are optional. The code should work MUSH-side as-is, but if you want to incorporate it into the profile and/or chargen, follow the steps below.

## Profile (optional)
To have inklings viewable on the web profile, you need to make the following changes:

open ares/ares-webportal/app/templates/components/profile-custom-tabs.hbs and add the following line:

    <li><a data-toggle="tab" href="#systemhints">Inklings</a></li>

open ares/ares-webportal/app/templates/components/profile-custom.hbs and add the following lines:

    <div id="systemhints" class="tab-pane fade">
      <h2>Inklings & Secrets</h2>
      {{#each char.custom.inklings as |inkling|}}
        <h3>{{inkling.name}}</h3>
        <p>{{{ansi-format text=inkling.desc}}}</p>
     {{else}}
        <p>This character has no Inklings.</p>
      {{/each}}
    </div>

Open aresmush/plugins/profile/custom_char_fields.rb and modify the get_fields_for_viewing:

    def self.get_fields_for_viewing(char, viewer)
    return {
            inklings: Inklings.get_inklings_for_web_viewing(char, viewer)
       }
    end

When finished, from the MUSH, type:

    load profile

then:

    website/deploy
    

Once the website has redeployed, the tab should appear on the profile.

## CharGen (optional)
To add Inklings to chargen, you'll need to do the following:

Open ares-webportal/app/templates/components/chargen-custom-tabs.hbs and add:

    <li><a data-toggle="tab" href="#systemextras">Extras</a></li>

Open ares-webportal/app/templates/components/chargen-custom.hbs and add:

    <div id="systemextras" class="tab-pane fade">
    <h2>Inklings & Secrets</h2>
    <p>{{char.custom.inklings_blurb}}</p>
    {{#each char.custom.inklings as |inkling|}}
    {{input type="text" value=inkling.name size=25}}
    <button class="btn btn-default" id="deleteinkling" {{action 'deleteInkling' inkling.name}}><i class="fa fa-trash" aria-label="Delete Inkling"></i></button>
    {{textarea value=inkling.desc cols="80" rows=5}}
    {{/each}}
    <button class="btn btn-default" id="addinkling" {{action 'addInkling'}}>Add Inkling</button>
    </div>

In aresmush/plugins/profile/custom_char_fields.rb, change the following:

      def self.get_fields_for_chargen(char)
          return {
            inklings: Inklings.get_inklings_for_web_editing(char),
            inklings_blurb: Inklings.get_blurb_for_web()
          }
      end
      
and

    def self.save_fields_from_chargen(char, chargen_data)
        return {
        inklings: Inklings.save_inklings_from_chargen(char, chargen_data)
      }
      
To check for Inklings during chargen review, replace 'return nil' in aresmush/plugins/chargen/custom_app_review.rb with:

    Inklings.check_inklings_for_chargen(char)
    
Add to ares-webportal/app/components/custom-chargen.js:

    onUpdate: function() {
    // Return a hash containing your data.  Character data will be in 'char'.  For example:
    //
    let data = {};
      this.get('char.custom.inklings').filter(t => t.name && t.name.length > 0)
         .forEach(t => data[t.name] = t.desc);
      return data;
     },

    actions: {
        addInkling() {
          this.get('char.custom.inklings').pushObject(EmberObject.create( {name: "New Inkling", desc: "Enter a Description"} ));
        },
        deleteInkling(name) {
          let found = this.get('char.custom.inklings').find(t => t.name === name);
          if (found) {
            this.get('char.custom.inklings').removeObject(found);
          }
        }
      }
    });



Then do:

    load all
    website/deploy
