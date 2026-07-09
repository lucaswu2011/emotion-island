import Foundation

/// 生活场景 · 英文话术补丁
extension ScenarioLibrary {

    private struct EnglishPatch {
        let extraKeywords: [String]
        let responsesEN: [String]
        let followUpsEN: [String]
        let gentleOnly: Bool

        init(
            extraKeywords: [String] = [],
            responsesEN: [String],
            followUpsEN: [String] = [],
            gentleOnly: Bool = false
        ) {
            self.extraKeywords = extraKeywords
            self.responsesEN = responsesEN
            self.followUpsEN = followUpsEN
            self.gentleOnly = gentleOnly
        }
    }

    static var lifePositiveLocalized: [Template] {
        localize(lifePositive, patches: lifePositiveEN)
    }

    static var lifeNegativeLocalized: [Template] {
        localize(lifeNegative, patches: lifeNegativeEN)
    }

    private static func localize(_ templates: [Template], patches: [String: EnglishPatch]) -> [Template] {
        templates.map { template in
            guard let patch = patches[template.id] else { return template }
            return Template(
                id: template.id,
                keywords: template.keywords + patch.extraKeywords,
                tone: template.tone,
                priority: template.priority,
                responses: template.responses,
                followUps: template.followUps,
                emojis: template.emojis,
                responsesEN: patch.responsesEN,
                followUpsEN: patch.followUpsEN.isEmpty ? template.followUps : patch.followUpsEN,
                gentleOnly: patch.gentleOnly || template.gentleOnly
            )
        }
    }

    private static let lifePositiveEN: [String: EnglishPatch] = [
        "life_family_reconcile": EnglishPatch(
            extraKeywords: ["talked things through", "misunderstanding cleared", "reconciled"],
            responsesEN: [
                "Finally clearing the air with family — that's such a weight off.",
                "Reconciliation is bittersweet. There's no winner in family — just being heard.",
            ],
            followUpsEN: ["Who spoke first?", "Do you feel lighter now?"]
        ),
        "life_ldr_meet": EnglishPatch(
            extraKeywords: ["long distance", "finally saw", "finally met"],
            responsesEN: [
                "All that screen-longing finally became a real hug — worth every mile.",
                "Long-distance reunions feel like charging your soul.",
            ],
            followUpsEN: ["What did you do first?", "When's the next visit?"]
        ),
        "life_partner_surprise": EnglishPatch(
            extraKeywords: ["remembered what I said", "planned everything"],
            responsesEN: [
                "Being remembered like that feels grounding — they were listening.",
                "When someone loves you well, you feel like the most special person alive.",
            ],
            followUpsEN: ["What surprised you most?", "Were you moved?"]
        ),
        "life_illness_cured": EnglishPatch(
            extraKeywords: ["finally cured", "eczema gone", "stopped coughing"],
            responsesEN: [
                "Recurring illness wears you down — finally better feels like breathing again.",
                "So glad you're past it. Healthy feels so good.",
            ],
            followUpsEN: ["What helped you heal?", "First thing you want to do?"]
        ),
        "life_checkup_ok": EnglishPatch(
            extraKeywords: ["follow-up normal", "false alarm", "results fine"],
            responsesEN: [
                "Waiting for results is torture — 'all clear' is the best news.",
                "False alarms remind us how precious health is.",
            ],
            followUpsEN: ["Were you anxious waiting?", "Take better care now?"]
        ),
        "life_business_done": EnglishPatch(
            extraKeywords: ["one trip", "no queue", "half an hour"],
            responsesEN: [
                "Bureaucracy in one go — rare win. Smooth errands lift the whole day.",
                "One-trip success! No second visit — today's little miracle.",
            ],
            followUpsEN: ["Lots of prep?", "Treat yourself after?"]
        ),
        "life_good_deal": EnglishPatch(
            extraKeywords: ["half price", "great deal", "bargain"],
            responsesEN: [
                "Deal-hunting joy — same thing, less money, feels like winning.",
                "That 'I got a steal' feeling beats the thing itself.",
            ],
            followUpsEN: ["How'd you find it?", "How much cheaper?"]
        ),
        "life_social_kindness": EnglishPatch(
            extraKeywords: ["started talking to me", "saved me from awkward"],
            responsesEN: [
                "For social anxiety, a kind stranger is sunlight.",
                "Stranger kindness at your lowest stays with you.",
            ],
            followUpsEN: ["So grateful?", "Talk again after?"]
        ),
        "life_help_thanked": EnglishPatch(
            extraKeywords: ["thanked me", "bubble tea"],
            responsesEN: [
                "Helping others warms you too — sincere thanks glows all day.",
                "Kindness goes both ways.",
            ],
            followUpsEN: ["Feel good after?", "Often help others?"]
        ),
        "life_pet_comfort": EnglishPatch(
            extraKeywords: ["cat curled", "dog stayed with me"],
            responsesEN: [
                "Pets know without words — your heart just softens.",
                "Silent company when you're lowest — that's why we keep them.",
            ],
            followUpsEN: ["Usually this clingy?", "Feel better?"]
        ),
        "life_pet_skill": EnglishPatch(
            extraKeywords: ["learned to shake", "new trick"],
            responsesEN: [
                "Teaching day by day finally pays off — prouder than learning yourself.",
                "New skill unlocked! Your patience showed.",
            ],
            followUpsEN: ["Frustrating to train?", "Reward them?"]
        ),
        "life_catch_train": EnglishPatch(
            extraKeywords: ["doors closed", "made the train"],
            responsesEN: [
                "Sprinting and making it by a second — luck maxed out.",
                "One second later and it's reschedule hell.",
            ],
            followUpsEN: ["Running whole way?", "Still breathless?"]
        ),
        "life_travel_warm": EnglishPatch(
            extraKeywords: ["host lovely", "locals helped"],
            responsesEN: [
                "Travel magic is often people, not places.",
                "Warm locals make a city feel gentle.",
            ],
            followUpsEN: ["Best surprise?", "Beat expectations?"]
        ),
        "life_figured_out": EnglishPatch(
            extraKeywords: ["suddenly made sense", "let it go"],
            responsesEN: [
                "That click when things make sense — weight lifts.",
                "You released yourself. Often we're stuck in our heads.",
            ],
            followUpsEN: ["What triggered it?", "Lighter now?"]
        ),
        "life_rainy_cozy": EnglishPatch(
            extraKeywords: ["cozy at home", "rainy day"],
            responsesEN: [
                "Rain outside, warm inside — the world can wait.",
                "Lazy rain-day peace when you don't have to be anywhere.",
            ],
            followUpsEN: ["Rainy-day ritual?", "Snacks too?"]
        ),
        "life_rental_decorated": EnglishPatch(
            extraKeywords: ["decorated my rental", "cozy room"],
            responsesEN: [
                "Rented walls, but the life inside is yours — home should feel like shelter.",
                "Small space, big heart — you made it yours.",
            ],
            followUpsEN: ["Favorite corner?", "Any cozy upgrades?"]
        ),
        "life_landlord_good": EnglishPatch(
            extraKeywords: ["great landlord", "no rent hike"],
            responsesEN: [
                "A fair landlord is rental gold — peace of mind matters.",
                "No drama, no surprise hikes — that's rare luck.",
            ],
            followUpsEN: ["Anything else kind?", "Staying long?"]
        ),
        "life_deep_clean": EnglishPatch(
            extraKeywords: ["deep clean", "declutter"],
            responsesEN: [
                "Watching chaos turn tidy clears the mind too.",
                "Declutter the room, declutter the mood.",
            ],
            followUpsEN: ["Best area done?", "Hard to toss anything?"]
        ),
        "life_cooking_success": EnglishPatch(
            extraKeywords: ["first time baking", "restaurant quality"],
            responsesEN: [
                "First try and nailed it — chef era unlocked.",
                "From ingredients to plate — that pride hits different.",
            ],
            followUpsEN: ["Any hiccups?", "Next dish?"]
        ),
        "life_driving_pass": EnglishPatch(
            extraKeywords: ["passed driving test", "first try"],
            responsesEN: [
                "All those early mornings paid off — license incoming.",
                "Heart in throat, then relief — you earned it.",
            ],
            followUpsEN: ["Scariest moment?", "Coach rough on you?"]
        ),
        "life_skill_work": EnglishPatch(
            extraKeywords: ["first full song", "finished drawing"],
            responsesEN: [
                "Zero to finished piece — quiet progress adds up.",
                "Showing up repeatedly — that's the win.",
            ],
            followUpsEN: ["Hardest part?", "Next project?"]
        ),
        "life_haircut_good": EnglishPatch(
            extraKeywords: ["love my new hair", "good haircut"],
            responsesEN: [
                "Good stylist energy — you look like you again, but better.",
                "Great hair days last for days.",
            ],
            followUpsEN: ["How'd you describe it?", "Take photos?"]
        ),
        "life_skincare_works": EnglishPatch(
            extraKeywords: ["skin cleared up", "skincare working"],
            responsesEN: [
                "Consistency showing on your face — confidence boost.",
                "Found what works after all those misses.",
            ],
            followUpsEN: ["Best step?", "Skincare fails before?"]
        ),
        "life_file_recovered": EnglishPatch(
            extraKeywords: ["recovered deleted file", "restored from cloud"],
            responsesEN: [
                "Deleted and rescued — heart attack to relief.",
                "Thank goodness for backups or recovery tools.",
            ],
            followUpsEN: ["How recovered?", "Backup plan now?"]
        ),
        "life_tech_deal": EnglishPatch(
            extraKeywords: ["lowest price ever", "tech deal"],
            responsesEN: [
                "Wait-for-sale victory — feels better than impulse buy.",
                "Great price, great condition — jackpot.",
            ],
            followUpsEN: ["How much saved?", "How long waiting?"]
        ),
        "life_old_friend": EnglishPatch(
            extraKeywords: ["old friend reached out", "remembered my birthday"],
            responsesEN: [
                "Being remembered across distance — some bonds don't fade.",
                "Sudden hello from the past — warm and bittersweet.",
            ],
            followUpsEN: ["How long apart?", "Awkward or easy?"]
        ),
        "life_gift_liked": EnglishPatch(
            extraKeywords: ["loved my gift", "posted about it"],
            responsesEN: [
                "Small gift, big reception — your care was seen.",
                "Giving joy returns joy.",
            ],
            followUpsEN: ["Their reaction?", "Often gift others?"]
        ),
        "life_concert_ticket": EnglishPatch(
            extraKeywords: ["got concert tickets", "sold out instantly"],
            responsesEN: [
                "Ticket secured — see your favorite live!",
                "Beat the queue — main-character luck.",
            ],
            followUpsEN: ["Nerve-wracking?", "Song you're hyped for?"]
        ),
        "life_handcraft_done": EnglishPatch(
            extraKeywords: ["finished lego", "handmade"],
            responsesEN: [
                "Piece by piece, night by night — that's dedication.",
                "Made with your hands hits different.",
            ],
            followUpsEN: ["Any mistakes?", "Next craft?"]
        ),
        "life_commute_seat": EnglishPatch(
            extraKeywords: ["got a seat", "empty seat rush hour"],
            responsesEN: [
                "Rush hour seat — commuter lottery win.",
                "Less crush, better mood all day.",
            ],
            followUpsEN: ["Commute length?", "Do on the ride?"]
        ),
        "life_sunset_commute": EnglishPatch(
            extraKeywords: ["sunset on commute", "beautiful sky"],
            responsesEN: [
                "Nature's gift after a long day — worker's romance.",
                "Sky painted pink — tiredness softened.",
            ],
            followUpsEN: ["Got photos?", "Stopped to watch?"]
        ),
        "life_job_offer": EnglishPatch(
            extraKeywords: ["got the job", "job offer", "hired"],
            responsesEN: [
                "After all those applications and interviews — you earned this yes.",
                "The self-doubt nights pay off when the offer lands.",
            ],
            followUpsEN: ["Hardest interview round?", "How will you celebrate day one?"]
        ),
        "life_work_praised": EnglishPatch(
            extraKeywords: ["boss praised", "recognized at work"],
            responsesEN: [
                "Being seen for your effort — that's fuel.",
                "Real recognition at work beats empty praise any day.",
            ],
            followUpsEN: ["What was it for?", "Did you smile about it all day?"]
        ),
        "life_sleep_well": EnglishPatch(
            extraKeywords: ["slept well", "good night's sleep"],
            responsesEN: [
                "Real sleep reboots everything — world feels softer.",
                "Sleeping through the night — body finally rested.",
            ],
            followUpsEN: ["Been insomnia lately?", "First thing after waking?"]
        ),
        "life_stranger_help": EnglishPatch(
            extraKeywords: ["stranger helped", "kind person"],
            responsesEN: [
                "Stranger kindness hits like sunlight — lights up the whole day.",
                "Small acts of warmth keep the world going.",
            ],
            followUpsEN: ["Were you moved?", "Got to thank them?"]
        ),
        "life_package_found": EnglishPatch(
            extraKeywords: ["package found", "delivery recovered"],
            responsesEN: [
                "Waiting on a package is nerve-wracking — relief when it arrives.",
                "Thought you'd fight customer service — glad it's in your hands.",
            ],
            followUpsEN: ["How long?", "Something you waited for?"]
        ),
        "life_tax_refund": EnglishPatch(
            extraKeywords: ["tax refund", "unexpected refund"],
            responsesEN: [
                "Surprise money — life's little bonus.",
                "Didn't expect it — feels like a reward.",
            ],
            followUpsEN: ["How much?", "Spend or save?"]
        ),
        "life_habit_streak": EnglishPatch(
            extraKeywords: ["streak", "habit for 30 days"],
            responsesEN: [
                "Consistency compounds — you're more reliable than you think.",
                "Hardest part is not quitting mid-way — you did it.",
            ],
            followUpsEN: ["What kept you going?", "Next habit?"]
        ),
        "life_weekend_sleep_in": EnglishPatch(
            extraKeywords: ["slept in", "no alarm weekend"],
            responsesEN: [
                "Guilt-free sleep-in — worker luxury.",
                "Tension melts when the alarm stays off.",
            ],
            followUpsEN: ["First meal?", "World feel better?"]
        ),
        "life_plant_sprout": EnglishPatch(
            extraKeywords: ["plant sprouted", "new leaf"],
            responsesEN: [
                "You kept something alive — tiny green victory.",
                "New growth feels like life growing with it.",
            ],
            followUpsEN: ["What plant?", "How do you care for it?"]
        ),
        "life_book_resonance": EnglishPatch(
            extraKeywords: ["book moved me", "passage resonated"],
            responsesEN: [
                "When a book says what you've been feeling — magic.",
                "Good words meet you on an ordinary day.",
            ],
            followUpsEN: ["Which book?", "Which line?"]
        ),
        "life_flight_luck": EnglishPatch(
            extraKeywords: ["upgrade", "good seat", "flight luck"],
            responsesEN: [
                "Travel luck makes airports feel friendly.",
                "Little surprises lighten the whole trip.",
            ],
            followUpsEN: ["Planned or surprise?", "Mood after landing?"]
        ),
        "life_courage_spoke": EnglishPatch(
            extraKeywords: ["finally said it", "spoke up", "confessed"],
            responsesEN: [
                "Courage itself is the win — braver than yesterday.",
                "Hands shaking maybe — but you said it. That counts.",
            ],
            followUpsEN: ["Lighter or more nervous?", "Their reaction?"]
        ),
        "life_adopt_pet": EnglishPatch(
            extraKeywords: ["adopted pet", "brought home"],
            responsesEN: [
                "New family member — home feels softer already.",
                "Adoption is second chances for both of you.",
            ],
            followUpsEN: ["First night okay?", "Named yet?"]
        ),
        "life_coffee_surprise": EnglishPatch(
            extraKeywords: ["coffee surprisingly good", "drink hit"],
            responsesEN: [
                "Random order, perfect taste — small bright spot.",
                "First sip 'yes this' — instant mood lift.",
            ],
            followUpsEN: ["What flavor?", "Adding to regular order?"]
        ),
        "life_rainbow_spot": EnglishPatch(
            extraKeywords: ["saw a rainbow", "double rainbow"],
            responsesEN: [
                "Rainbow after rain — gentle reminder it'll be okay.",
                "Looked up and paused — nature's quiet comfort.",
            ],
            followUpsEN: ["Photo?", "What were you doing?"]
        ),
        "life_off_day": EnglishPatch(
            extraKeywords: ["day off", "vacation day", "no work today"],
            responsesEN: [
                "Finally your day — no pings, no rush.",
                "Rest isn't lazy — you've earned recharge.",
            ],
            followUpsEN: ["Plans?", "What waited for this day?"]
        ),
        "life_dentist_ok": EnglishPatch(
            extraKeywords: ["wisdom tooth", "dentist went fine"],
            responsesEN: [
                "Dread is often worse than the chair — you made it.",
                "Checked off something you've been avoiding — nice.",
            ],
            followUpsEN: ["Nervous beforehand?", "Aftercare tips?"]
        ),
    ]

    private static let lifeNegativeEN: [String: EnglishPatch] = [
        "life_cold_violence": EnglishPatch(
            extraKeywords: ["silent treatment", "not replying", "ghosting"],
            responsesEN: [
                "Silent treatment is cruel — limbo hurts worse than fighting.",
                "You want to fix things; they vanish. That helpless anger is valid.",
            ],
            followUpsEN: ["What started it?", "Angry or hurt more?"]
        ),
        "life_parent_pressure": EnglishPatch(
            extraKeywords: ["marriage pressure", "compare me"],
            responsesEN: [
                "Closest people pushing someone else's timeline — suffocating.",
                "They say 'for your good' but never ask what you want.",
            ],
            followUpsEN: ["Told them your view?", "How do you respond?"]
        ),
        "life_family_sandwich": EnglishPatch(
            extraKeywords: ["stuck in the middle", "both sides venting"],
            responsesEN: [
                "Stuck between people you love — nowhere to put your stress.",
                "Mediating often means both sides blame you.",
            ],
            followUpsEN: ["What started it?", "Tried mediating?"]
        ),
        "life_diet_rebound": EnglishPatch(
            extraKeywords: ["gained it back", "yo-yo"],
            responsesEN: [
                "Yo-yo weight is crushing — the scale mocks your effort.",
                "Anyone would spiral when effort vanishes overnight.",
            ],
            followUpsEN: ["What method?", "Ever worked better?"]
        ),
        "life_period_pain": EnglishPatch(
            extraKeywords: ["period cramps", "PMS"],
            responsesEN: [
                "Cramps wreck your day — just ache through it.",
                "Pain plus mood crash — go easy on yourself.",
            ],
            followUpsEN: ["Anything helps?", "Better now?"]
        ),
        "life_sports_injury": EnglishPatch(
            extraKeywords: ["sprained", "pulled muscle"],
            responsesEN: [
                "Habit built, then injury — heal first, no rush.",
                "Forced rest isn't failure.",
            ],
            followUpsEN: ["How bad?", "How happen?"]
        ),
        "life_shopping_bad": EnglishPatch(
            extraKeywords: ["not like photos", "fake product"],
            responsesEN: [
                "Waiting for disappointment, then fighting returns.",
                "Paying for garbage while they dodge blame — infuriating.",
            ],
            followUpsEN: ["Return accepted?", "Which platform?"]
        ),
        "life_queue_cut": EnglishPatch(
            extraKeywords: ["cut in line"],
            responsesEN: [
                "You waited fairly; they didn't. Entitlement ruins everything.",
                "One jumper and the mood sours.",
            ],
            followUpsEN: ["Say anything?", "Others help?"]
        ),
        "life_bad_service": EnglishPatch(
            extraKeywords: ["rude staff", "passed around"],
            responsesEN: [
                "Hassle plus attitude — your time shouldn't buy disrespect.",
                "Bounced between departments, zero progress.",
            ],
            followUpsEN: ["Resolved?", "Complaint channel?"]
        ),
        "life_prepaid_scam": EnglishPatch(
            extraKeywords: ["gym closed", "store ran away"],
            responsesEN: [
                "Paid upfront, they vanish — money gone.",
                "Prepaid 'deals' that become scams.",
            ],
            followUpsEN: ["How much lost?", "Others too?"]
        ),
        "life_social_outcast": EnglishPatch(
            extraKeywords: ["can't fit in", "outsider"],
            responsesEN: [
                "Everyone grouped while you hover at the edge.",
                "Want in, afraid to intrude — no winning.",
            ],
            followUpsEN: ["How long there?", "Talked to anyone?"]
        ),
        "life_secret_betrayed": EnglishPatch(
            extraKeywords: ["shared my secret", "betrayed trust"],
            responsesEN: [
                "You trusted them; they gossiped. Only you meant it.",
                "Soft spot weaponized — no wonder you shut down.",
            ],
            gentleOnly: true
        ),
        "life_public_tease": EnglishPatch(
            extraKeywords: ["joked about my flaws", "humiliated"],
            responsesEN: [
                "Cruelty disguised as humor — not your fault.",
                "Public humiliation burns when you can't react.",
            ],
            followUpsEN: ["Push back?", "Others laugh?"]
        ),
        "life_promise_failed": EnglishPatch(
            extraKeywords: ["let them down", "messed up"],
            responsesEN: [
                "You cared enough to feel guilty. You tried.",
                "One miss doesn't erase your care.",
            ],
            followUpsEN: ["They upset?", "What blocked you?"]
        ),
        "life_pet_sick": EnglishPatch(
            extraKeywords: ["cat sick", "dog surgery"],
            responsesEN: [
                "Pets can't say where it hurts — watching them wilt breaks you.",
                "Scary when they're unwell. Hang in there together.",
            ],
            followUpsEN: ["What's wrong?", "Improving?"]
        ),
        "life_pet_destroy": EnglishPatch(
            extraKeywords: ["destroyed house", "chewed up"],
            responsesEN: [
                "Chaos at the door — fury, then those eyes.",
                "Infuriating and somehow still forgivable.",
            ],
            followUpsEN: ["Worst damage?", "Scold them?"]
        ),
        "life_pet_lost": EnglishPatch(
            extraKeywords: ["pet ran away", "lost my cat"],
            responsesEN: [
                "They were just there — now gone. Mind races.",
                "Search nearby, notices up — many find their way back.",
            ],
            gentleOnly: true
        ),
        "life_missed_transport": EnglishPatch(
            extraKeywords: ["missed the train", "missed flight"],
            responsesEN: [
                "Watching it leave by seconds — gutted.",
                "Schedule and ticket both gone.",
            ],
            gentleOnly: true
        ),
        "life_car_accident": EnglishPatch(
            extraKeywords: ["rear-ended", "hit my car"],
            responsesEN: [
                "Parked fine, still hit — then insurance hell.",
                "Plans wrecked through no fault of yours.",
            ],
            followUpsEN: ["Bad damage?", "Their fault?"]
        ),
        "life_travel_scam": EnglishPatch(
            extraKeywords: ["not like photos", "shopping tour"],
            responsesEN: [
                "Built up the trip, arrived to lies.",
                "Time and money for a scam tour.",
            ],
            followUpsEN: ["Worst stop?", "Anything good?"]
        ),
        "life_birthday_forgotten": EnglishPatch(
            extraKeywords: ["birthday forgotten", "no one remembered"],
            responsesEN: [
                "Everyone celebrating, your silence — I remember. Happy birthday.",
                "People get busy; treat yourself today anyway.",
            ],
            followUpsEN: ["Do something for yourself?", "Usually how you spend it?"]
        ),
        "life_nostalgia": EnglishPatch(
            extraKeywords: ["old photos", "old song"],
            responsesEN: [
                "Nostalgia is sweet and achy — can't go back.",
                "You miss who you were then, not just when.",
            ],
            followUpsEN: ["What era?", "Someone on your mind?"]
        ),
        "life_effort_failed": EnglishPatch(
            extraKeywords: ["still didn't get in", "countless applications"],
            responsesEN: [
                "Everything in and still short — cry if you need to.",
                "You did your best. One result doesn't erase the road you walked.",
            ],
            gentleOnly: true
        ),
        "life_apathy": EnglishPatch(
            extraKeywords: ["nothing interests me", "numb"],
            responsesEN: [
                "Emotions get tired — don't force joy. Numb seasons pass.",
                "That hollow gap — we'll take it slowly.",
            ],
            followUpsEN: ["How long?", "Anything that used to help?"]
        ),
        "life_rent_hike": EnglishPatch(
            extraKeywords: ["rent increase", "evicted", "forced to move"],
            responsesEN: [
                "Stable home, then sudden change — no buffer, all panic.",
                "Hunting and packing when you didn't plan to — exhausting.",
            ],
            followUpsEN: ["How long to move?", "Next place lined up?"]
        ),
        "life_neighbor_noise": EnglishPatch(
            extraKeywords: ["noisy neighbor", "construction noise"],
            responsesEN: [
                "Can't rest, can't relax — anger with nowhere to go.",
                "Home should be quiet; noise steals peace.",
            ],
            followUpsEN: ["Talked to them?", "How long ongoing?"]
        ),
        "life_roommate_bad": EnglishPatch(
            extraKeywords: ["bad roommate", "never cleans"],
            responsesEN: [
                "Shared mess, shared misery — speaking up risks drama.",
                "Your stuff touched without ask — no boundaries.",
            ],
            followUpsEN: ["Confronted them?", "Keep tolerating?"]
        ),
        "life_appliance_broken": EnglishPatch(
            extraKeywords: ["fridge broke", "AC died"],
            responsesEN: [
                "Appliance dies, life stops, wallet hurts.",
                "Spoiled food plus repair bill — double hit.",
            ],
            followUpsEN: ["What broke?", "Repair when?"]
        ),
        "life_coach_yelled": EnglishPatch(
            extraKeywords: ["coach yelled at me", "humiliated driving"],
            responsesEN: [
                "Public yelling while you're already nervous — cruel and counterproductive.",
                "Paying to learn shouldn't mean paying in dignity.",
            ],
            followUpsEN: ["What did they say?", "Switch coach?"]
        ),
        "life_skill_stuck": EnglishPatch(
            extraKeywords: ["can't learn", "plateau"],
            responsesEN: [
                "Plateaus happen — you're still ahead of day one.",
                "Frustration means you care. Rest, then retry.",
            ],
            followUpsEN: ["Hardest step?", "Class or self-taught?"]
        ),
        "life_haircut_fail": EnglishPatch(
            extraKeywords: ["bad haircut", "hair disaster"],
            responsesEN: [
                "Hair regret — mirror dread is real. It grows back.",
                "Expected magic, got trauma. Time heals bangs too.",
            ],
            followUpsEN: ["How bad?", "Complained there?"]
        ),
        "life_skin_breakout": EnglishPatch(
            extraKeywords: ["breakout", "allergic reaction face"],
            responsesEN: [
                "Skin flares hit confidence — most people aren't staring.",
                "Itchy, red, hiding — gentle care, no picking.",
            ],
            followUpsEN: ["Know the trigger?", "Using medicine?"]
        ),
        "life_outfit_ignored": EnglishPatch(
            extraKeywords: ["dressed up ignored", "no compliments"],
            responsesEN: [
                "Dress for you, not applause — you looked good for you.",
                "No comment stings, but your taste is yours.",
            ],
            followUpsEN: ["You liked it?", "Care what others think?"]
        ),
        "life_blue_screen": EnglishPatch(
            extraKeywords: ["blue screen", "lost unsaved work"],
            responsesEN: [
                "Hours of work, one crash — soul leaves body.",
                "Deadline looming, start over — rage and panic.",
            ],
            followUpsEN: ["Deadline when?", "Any recovery?"]
        ),
        "life_phone_broken": EnglishPatch(
            extraKeywords: ["cracked screen", "phone water damage"],
            responsesEN: [
                "Spiderweb screen — expensive fix or limping along.",
                "Water damage — repair cost plus lost memories.",
            ],
            followUpsEN: ["How bad?", "Important data inside?"]
        ),
        "life_account_lost": EnglishPatch(
            extraKeywords: ["account hacked", "banned account"],
            responsesEN: [
                "Years invested, gone overnight — rage and grief.",
                "No fault, no account — appeal limbo.",
            ],
            followUpsEN: ["Know why?", "Contacted support?"]
        ),
        "life_gift_money": EnglishPatch(
            extraKeywords: ["wedding gifts", "red envelope broke"],
            responsesEN: [
                "Social obligations drain salary — can't skip, can't afford.",
                "Clustered events, empty wallet.",
            ],
            followUpsEN: ["How much this month?", "Local norm amount?"]
        ),
        "life_borrow_awkward": EnglishPatch(
            extraKeywords: ["asked to lend money", "never pays back"],
            responsesEN: [
                "Guilt-loan traps — your money, your call.",
                "Small unpaid loans add up and sour friendship.",
            ],
            followUpsEN: ["Will you lend?", "Burned before?"]
        ),
        "life_family_visit": EnglishPatch(
            extraKeywords: ["family reunion tired", "holiday relatives"],
            responsesEN: [
                "Smile marathon — questions, politics, no rest.",
                "Emotional labor disguised as holiday cheer.",
            ],
            followUpsEN: ["Worst question?", "Coping tricks?"]
        ),
        "life_show_soldout": EnglishPatch(
            extraKeywords: ["sold out", "event cancelled"],
            responsesEN: [
                "Built-up hope, empty result — letdown hurts.",
                "Outfits planned, then cancelled — future chance maybe.",
            ],
            followUpsEN: ["Waited how long?", "Try again?"]
        ),
        "life_show_bad_ending": EnglishPatch(
            extraKeywords: ["bad ending", "show ruined"],
            responsesEN: [
                "Invested months, got slop — feelings wasted.",
                "Worse than never watching — betrayal at the finale.",
            ],
            followUpsEN: ["Worst part?", "Ideal ending?"]
        ),
        "life_cinema_rude": EnglishPatch(
            extraKeywords: ["kids kicking seat", "talking in cinema"],
            responsesEN: [
                "Paid ticket, got chaos — mood ruined.",
                "No public manners, no parent control.",
            ],
            followUpsEN: ["Spoke up?", "Follow plot at all?"]
        ),
        "life_commute_lost": EnglishPatch(
            extraKeywords: ["lost earphones commute", "stepped on shoes"],
            responsesEN: [
                "Crush hour — can't even bend to pick things up.",
                "New shoes, first day, instant footprints — ouch.",
            ],
            followUpsEN: ["Found it?", "Cleanable?"]
        ),
        "life_no_bike": EnglishPatch(
            extraKeywords: ["no shared bikes", "walked extra"],
            responsesEN: [
                "Need a ride, zero bikes — walk of shame to work.",
                "Urgent moment, empty rack — brutal luck.",
            ],
            followUpsEN: ["Late?", "Usually bike?"]
        ),
        "life_moving_exhaust": EnglishPatch(
            extraKeywords: ["moving exhausted", "packing forever"],
            responsesEN: [
                "Moving is a sport nobody trains for — boxes never end.",
                "Body wrecked, home still chaos — pace yourself.",
            ],
            followUpsEN: ["DIY or movers?", "Excited about new place?"]
        ),
        "life_overtime_crash": EnglishPatch(
            extraKeywords: ["overtime every day", "working late", "all-nighter work"],
            responsesEN: [
                "Nonstop grind empties you — rest isn't optional tonight.",
                "Overtime numbness is real — your effort is visible.",
            ],
            followUpsEN: ["How long straight?", "Talked to manager?"]
        ),
        "life_credit_stolen": EnglishPatch(
            extraKeywords: ["stole credit", "took my idea"],
            responsesEN: [
                "Your work, someone else's name — infuriating.",
                "Watching others claim your effort — rage is fair.",
            ],
            followUpsEN: ["Confront them?", "Boss knows?"]
        ),
        "life_boss_micromanage": EnglishPatch(
            extraKeywords: ["micromanaging boss", "watches everything"],
            responsesEN: [
                "Breathing down your neck — exhausting and trust-killing.",
                "Not workload — lack of trust that drains you.",
            ],
            followUpsEN: ["Recent change?", "Set boundaries?"]
        ),
        "life_salary_late": EnglishPatch(
            extraKeywords: ["late paycheck", "pay cut"],
            responsesEN: [
                "Month of work, money delayed — anxiety and anger.",
                "Pay is dignity — late or cut hits hard.",
            ],
            followUpsEN: ["How late?", "Any explanation?"]
        ),
        "life_insomnia": EnglishPatch(
            extraKeywords: ["insomnia", "can't sleep", "up at 3am"],
            responsesEN: [
                "Brain on fast-forward at night — brutal next day.",
                "Insomnia isn't just tired — it's dull ache all over.",
            ],
            followUpsEN: ["Recent?", "What's on your mind?"]
        ),
        "life_food_poison": EnglishPatch(
            extraKeywords: ["food poisoning", "ate something bad"],
            responsesEN: [
                "Stomach misery — lie down, hydrate, don't push.",
                "One bad meal, whole day ruined — unfair.",
            ],
            followUpsEN: ["Know what it was?", "Feeling better?"]
        ),
        "life_atm_swallow": EnglishPatch(
            extraKeywords: ["ATM ate card", "card swallowed"],
            responsesEN: [
                "Card gone, bank trip added — panic and hassle.",
                "Simple errand turned ordeal.",
            ],
            followUpsEN: ["Got card back?", "In a rush?"]
        ),
        "life_parking_fine": EnglishPatch(
            extraKeywords: ["parking ticket", "traffic fine"],
            responsesEN: [
                "Unexpected fine — money plus frustration.",
                "Sometimes minutes or signs — still costly.",
            ],
            followUpsEN: ["Why fined?", "How much?"]
        ),
        "life_ghosted": EnglishPatch(
            extraKeywords: ["ghosted", "left on read", "stopped replying"],
            responsesEN: [
                "Sudden silence hurts more than a clear no — loops in your head.",
                "Being left hanging isn't your fault — they lacked courage.",
            ],
            followUpsEN: ["How was it before?", "Angry or sad?"]
        ),
        "life_friend_flake": EnglishPatch(
            extraKeywords: ["flaked", "cancelled last minute", "stood me up"],
            responsesEN: [
                "Plans dashed last minute — disappointment and anger.",
                "Repeated flaking erodes trust — your time matters.",
            ],
            followUpsEN: ["Good excuse?", "How many times?"]
        ),
        "life_group_excluded": EnglishPatch(
            extraKeywords: ["wasn't invited", "left out", "saw on social media"],
            responsesEN: [
                "Finding out via others' posts — sour and stinging.",
                "Not every hang needs you — being skipped still hurts.",
            ],
            followUpsEN: ["How found out?", "Asked them?"]
        ),
        "life_luggage_lost": EnglishPatch(
            extraKeywords: ["lost luggage", "bag didn't arrive"],
            responsesEN: [
                "Land tired, bag missing — stress spikes.",
                "Important stuff inside — helpless waiting.",
            ],
            followUpsEN: ["Found later?", "Anything critical inside?"]
        ),
        "life_hotel_bad": EnglishPatch(
            extraKeywords: ["bad hotel", "room not as pictured"],
            responsesEN: [
                "Expected rest, got disappointment — money wasted on peace.",
                "Bad stay ruins travel — more tired than before.",
            ],
            followUpsEN: ["Switch or refund?", "Worst part?"]
        ),
        "life_car_breakdown": EnglishPatch(
            extraKeywords: ["car broke down", "stranded"],
            responsesEN: [
                "Car dies mid-route — panic and plans shattered.",
                "Repair plus logistics — whole day derailed.",
            ],
            followUpsEN: ["You okay?", "How fixed?"]
        ),
        "life_social_anxiety_scroll": EnglishPatch(
            extraKeywords: ["social media anxiety", "comparison scroll"],
            responsesEN: [
                "Everyone's highlight reel vs your backstage — cruel math.",
                "Feeds show fragments — you're doing fine as you are.",
            ],
            followUpsEN: ["What triggered?", "Try less scrolling?"]
        ),
        "life_procrastinate_panic": EnglishPatch(
            extraKeywords: ["procrastinated", "deadline panic"],
            responsesEN: [
                "Last-minute panic — not lazy, frozen by pressure.",
                "Anxiety stacks — breathe, do what you can.",
            ],
            followUpsEN: ["How much left?", "Why the delay?"]
        ),
        "life_pest_home": EnglishPatch(
            extraKeywords: ["cockroach", "mouse at home", "pest"],
            responsesEN: [
                "Pests at home — skin crawl, safety gone.",
                "Disgust plus helplessness — home should feel safe.",
            ],
            followUpsEN: ["Exterminator?", "First time?"]
        ),
        "life_ac_heat": EnglishPatch(
            extraKeywords: ["AC broken", "too hot to sleep"],
            responsesEN: [
                "Summer without AC — sleep and sanity melt.",
                "Heat fries temper too — hydrate, stay cool.",
            ],
            followUpsEN: ["Repair when?", "Sleep plan tonight?"]
        ),
        "life_internet_outage": EnglishPatch(
            extraKeywords: ["internet down", "wifi out", "no network"],
            responsesEN: [
                "No net — work, chat, fun all frozen. Maddening.",
                "WFH plus outage — explosive combo.",
            ],
            followUpsEN: ["How long?", "Called provider?"]
        ),
        "life_first_day_nerves": EnglishPatch(
            extraKeywords: ["first day at work", "new job nerves"],
            responsesEN: [
                "Day one jitters are normal — new faces, new rules.",
                "Blind box feeling — give yourself time to settle.",
            ],
            followUpsEN: ["Scariest part?", "Nice colleague yet?"]
        ),
    ]
}
