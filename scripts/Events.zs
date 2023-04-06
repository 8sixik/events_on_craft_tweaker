import crafttweaker.api.events.CTEventManager;
import mods.gamestages.events.GameStageAdded;
import crafttweaker.api.event.tick.PlayerTickEvent;
import crafttweaker.api.world.Level;
import crafttweaker.api.util.math.RandomSource;
import crafttweaker.api.world.ServerLevel;
import crafttweaker.api.text.Component;
import crafttweaker.api.event.living.LivingDamageEvent;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.data.IntData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.event.entity.player.PlayerEvent;
import crafttweaker.api.entity.type.player.Player;
import crafttweaker.api.entity.effect.MobEffectInstance;
import crafttweaker.api.event.entity.living.LivingAttackEvent;
import crafttweaker.api.event.living.LivingDamageEvent;
import crafttweaker.api.event.living.LivingFallEvent;
import crafttweaker.api.world.Explosion;
import crafttweaker.api.event.entity.living.LivingDeathEvent;
import crafttweaker.api.world.ExplosionBlockInteraction;
import crafttweaker.api.entity.type.player.ServerPlayer;
import mods.gamestages.events.GameStageRemoved;
import crafttweaker.api.entity.Entity;


/*
    Events occur from 0 ticks to 12,000
    Events are reset from 14001 to 23400  
*/
CTEventManager.register<crafttweaker.api.event.tick.PlayerTickEvent>((event) => {
    var player = event.player;
    var level = player.level;

     if(level.isClientSide()) return;

    if(level.daytime <= 12000 && level.daytime >= 0 && !player.hasGameStage("EventWorld")){
        var RandomFloatEvent = level.random.nextFloat();

        if("PlayerWorldEvent" in player.getCustomData()){
            
        }
    }
    if(level.daytime >= 14001 && level.daytime <= 23400 && player.hasGameStage("EventWorld")){
        player.addGameStage("EventWorldRemove");
    }


    //Logic for the event to give the player a negative effect
    if("isPlayer" in player.getCustomData()){

        //Event logic
        if("EventWorldBadEffect" in player.getCustomData()){
            if(level.daytime == 12200){
                player.updateCustomData({
                    Effect2 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:unluck>, 999999, 1));
            }
            if(level.daytime == 13000){
                player.updateCustomData({
                    Effect3 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:bad_omen>, 999999, 5));
            }
            if(level.daytime == 14000){
                player.updateCustomData({
                    Effect4 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:slowness>, 999999, 1));
            }
            if(level.daytime == 15000){
                player.updateCustomData({
                    Effect5 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:hunger>, 999999, 1));
            }
            if(level.daytime == 16000){
                player.updateCustomData({
                    Effect6 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:weakness>, 999999, 1));
            }
            if(level.daytime == 17000){
                player.updateCustomData({
                    Effect7 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:mining_fatigue>, 999999, 1));
            }
            if(level.daytime == 18000){
                player.updateCustomData({
                    Effect8 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:poison>, 999999, 1));
            }
            if(level.daytime == 19000){
                player.updateCustomData({
                    Effect9 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:minecraft:nausea>, 999999, 1));
            }
            if(level.daytime == 20000){
                player.updateCustomData({
                    Effect10 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:majruszsdifficulty:bleeding>, 999999, 1));
            }
            if(level.daytime == 21000){
                player.updateCustomData({
                    Effect11 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:stalwart_dungeons:spore>, 999999, 1));
            }
            if(level.daytime == 22000){
                player.updateCustomData({
                    Effect12 : true as bool
                });
                player.addEffect(new MobEffectInstance(<mobeffect:stalwart_dungeons:burning>, 999999, 1));
            }
        }
    }
});

//The logic of events tied to taking damage
CTEventManager.register<crafttweaker.api.event.entity.living.LivingAttackEvent>((event) => {
    var DamageFloat = event.getAmount();
    var entity = event.getEntityLiving();
    var level = entity.level;
    var source = event.getSource();
    
    if(level.isClientSide()) return;
    if(source.directEntity == null || source.entity == null) return;
    
    if(entity.getRegistryName() == <resource:minecraft:player>) { 

        if("isPlayer" in entity.getCustomData()){

            //If a player has the data of the deadly damage event, then when receiving damage, he will die
            if("EventWorldDeadlyDamage" in entity.getCustomData()){
                if(!entity.isDeadOrDying() && entity.getHealth() > 0.0){
                    entity.kill();
                }   
            }

            //An event on cursed items. When taking damage, a random item from the inventory will be thrown away or removed
            if("EventWorldCursedItem" in entity.getCustomData()){
                if(!entity.isDeadOrDying() && entity.getHealth() > 0.0){
                    var player = entity as crafttweaker.api.entity.type.player.Player;
                    var randomItem = level.random.nextInt(0, player.inventory.getContainerSize());
                    var randomChance = level.random.nextFloat();
                    if(!player.inventory.isEmpty()){
                        var item = player.inventory.getItem(randomItem);
                        if(randomChance <= 0.1){
                            player.inventory.setItem(randomItem, <item:minecraft:air>);
                        }
                        else{
                            player.drop(item, false);
                            player.inventory.setItem(randomItem, <item:minecraft:air>);
                        }
                    }
                }
            }

            //An event that saves inventory when taking damage, and gives them back when reviving
            //Initially, there was an idea if the player dies, then the inventory is saved, but it didn't work out that way =(
            if(entity.isDeadOrDying() || entity.getHealth() <= 0.4){
                if("EventWorldSaveItems" in entity.getCustomData()){
                    var player = entity as crafttweaker.api.entity.type.player.Player;
                    IPlayer.setSaveInventory(player);
                    player.inventory.clearContent();
                }   
            }
        }
        else{
            //if("EventWorldSmallDamage" in source.directEntity.getCustomData() || "EventWorldSmallDamage" in source.entity.getCustomData()){
                // var Damage = DamageFloat % 50.0;
                // println(DamageFloat);
                // println(Damage);
            //}
        }
    }
});

//The logic of events tied to taking damage
CTEventManager.register<crafttweaker.api.event.living.LivingDamageEvent>((event) => {
    var DamageFloat = event.getAmount();
    var entity = event.getEntityLiving();
    var level = entity.level;
    var source = event.getSource();
    
    if(level.isClientSide()) return;
    if(source.directEntity == null || source.entity == null) return;

    if("isPlayer" in source.entity.getCustomData()){
        var EEntity as Entity = source.entity;
        var player = EEntity as crafttweaker.api.entity.type.player.Player;
        
        //An event in which any damage inflicted by a player will be reduced by 50%
        if("EventWorldSmallDamage" in source.directEntity.getCustomData() || "EventWorldSmallDamage" in source.entity.getCustomData()){
            var dam = (DamageFloat * 0.50);
            event.setAmount(dam);
            println(dam);
        }
        //An event in which any damage inflicted by a player will be increased by 50%
        if("EventWorldDoubleDamage" in source.directEntity.getCustomData() || "EventWorldDoubleDamage" in source.entity.getCustomData()){
            var dam = (DamageFloat * 0.50);
            event.setAmount(DamageFloat + dam);
            println(dam);
        }
    }
});

//Events that occur at the death of a mob
CTEventManager.register<crafttweaker.api.event.entity.living.LivingDeathEvent>((event) => {
    var entity = event.getEntityLiving();
    var level = entity.level;
    var source = event.getSource();
    
    if(level.isClientSide()) return;
    if(source.directEntity == null || source.entity == null) return;

    if(entity.getRegistryName() != <resource:minecraft:player>) {
        if("isPlayer" in source.entity.getCustomData()){

            //An event in which any mob killed by a player will explode
            if("EventWorldExplosion" in source.entity.getCustomData()){
                if(source.entity.getRegistryName() == <resource:minecraft:player> || source.directEntity.getRegistryName() == <resource:minecraft:player>){
                    entity.playSound(<soundevent:minecraft:entity.generic.explode>, 1.0, 1.0);
                    var boom = Explosion.create(level, entity.x, entity.y, entity.z, 5.0, false, <constant:minecraft:explosion/blockinteraction:break>, entity, source.setExplosion());
                    boom.explode();
                    boom.finalizeExplosion(true);
                }
            }
        }

        /*
        if("isPlayer" in entity.getCustomData()){
            if("EventWorldSaveItems" in entity.getCustomData()){
                var player = entity as crafttweaker.api.entity.type.player.Player;
                IPlayer.setSaveInventory(player);
                player.inventory.clearContent();
            }
        }
        */
    }
});


//Events during the player's respawn
CTEventManager.register<crafttweaker.api.event.entity.player.PlayerRespawnEvent>((event) => {
    var player = event.player;
    var level = player.level;

    if(level.isClientSide()) return;

    if("isPlayer" in player.getCustomData()){
        if("EventWorldSaveItems" in player.getCustomData()){
            for i in 0 .. player.inventory.getContainerSize(){
                IPlayer.giveInventoryItem(player, i);
            }
        }
    }
});

/*
CTEventManager.register<crafttweaker.api.event.living.LivingFallEvent>((event) => {
    var entity = event.getEntityLiving();
    var level = entity.level;

    if(level.isClientSide()) return;

    if(entity.getRegistryName() == <resource:minecraft:player>) { 
        if("isPlayer" in entity.getCustomData()){
            //if("EventWorldDeadlyDamage" in entity.getCustomData()){
                if(!entity.isDeadOrDying() && entity.getHealth() > 0.0){
                    entity.kill();
                }   
            //}
        }
    }
});
*/

CTEventManager.register<GameStageAdded>((event) => {
    var player = event.player;
    var level = player.level;
    var stage = event.stage;
    var serverLevel = player.commandSenderWorld as ServerLevel;
    var server = serverLevel.server;

    //List of events
    var dataKey = [
        "EventWorldDeadlyDamage",
        "EventWorldSmallDamage",
        "EventWorldCursedItem",
        "EventWorldBadEffect",
        "EventWorldBloodMoon",
        "EventWorldExplosion",
        "EventWorldDoubleDamage",
        "EventWorldRandomGive",
        "EventWorldSaveItems",
        "Experemental"
    ] as string[];

    //Event IDs
    var eventName = [
        "EventWorld",
        "EventWorldType1",
        "EventWorldType2",
        "EventWorldType3",
        "EventWorldType4",
        "EventWorldType5",
        "EventWorldType6",
        "EventWorldType7",
        "EventWorldType8",
        "EventWorldType9",
        "EventWorldType1t",
        "EventWorldType2t",
        "EventWorldType3t",
        "EventWorldType4t",
        "EventWorldType5t",
        "EventWorldType6t",
        "EventWorldType7t",
        "EventWorldType8t",
        "EventWorldType9t",
        "Experemental"
    ] as string[];
    
    if(stage == "EventWorldRemove"){
        
        for i in eventName {
            player.removeGameStage(i);
        }

        for i in dataKey {
            player.getCustomData().remove(i);
        }
        server.executeCommand("enhancedcelestials setLunarEvent enhancedcelestials:default", true);
    }

    //Manual give of events
    {
        if(stage == "EventWorldType1t"){
            player.addGameStage("EventWorldType1");
            server.executeCommand("title " + player.name + " title {\"text\":\"Смертельное прикосновение\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Любой полученный урон от мобов, будет смертельным !").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldDeadlyDamage : true as bool
            });
        }

        if(stage == "EventWorldType2t"){
            player.addGameStage("EventWorldType2");
            server.executeCommand("title " + player.name + " title {\"text\":\"Сильная слабость\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Любой урон по монстрам, будет уменшен на 50%").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldSmallDamage : true as bool
            });
        }
        
        if(stage == "EventWorldType3t"){
            player.addGameStage("EventWorldType3");
            server.executeCommand("title " + player.name + " title {\"text\":\"Проклятые предметы\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Если вы получите урон от мобов, случайные предмет из инвентаря будет удалён или выбрашен").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldCursedItem : true as bool
            });
        }

        if(stage == "EventWorldType4t"){
            player.addGameStage("EventWorldType4");
            server.executeCommand("title " + player.name + " title {\"text\":\"Плохое самочуствие\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] До конца дня на вас будут действовать негативные эффекты, которые вы будете получать каждые 1000 тиков").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldBadEffect : true as bool
            });
        }

        if(stage == "EventWorldType5t"){
            player.addGameStage("EventWorldType5");
            server.executeCommand("title " + player.name + " title {\"text\":\"Кровавая Луна\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Под эту кровавую луну, монстры станцуют на вашей могиле").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldBloodMoon : true as bool
            });
            server.executeCommand("enhancedcelestials setLunarEvent enhancedcelestials:super_blood_moon", true);
        }

        if(stage == "EventWorldType6t"){
            player.addGameStage("EventWorldType6");
            server.executeCommand("title " + player.name + " title {\"text\":\"Взрывные приколы\",\"color\":\"red\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] При смерте мобы создают взрыв").setStyle(<constant:formatting:red>));
            player.updateCustomData({
                EventWorldExplosion : true as bool
            });
        }

        if(stage == "EventWorldType7t"){
            player.addGameStage("EventWorldType7");
            server.executeCommand("title " + player.name + " title {\"text\":\"Сила Геркулеса\",\"color\":\"green\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Любой нанесённый вами урон будет увеличен на 50%").setStyle(<constant:formatting:green>));
            player.updateCustomData({
                EventWorldDoubleDamage : true as bool
            });
        }

        if(stage == "EventWorldType8t"){
            player.addGameStage("EventWorldType8");
            server.executeCommand("title " + player.name + " title {\"text\":\"Подарки с небес\",\"color\":\"green\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] В течении длня вы будете получать случайные предметы").setStyle(<constant:formatting:green>));
            player.updateCustomData({
                EventWorldRandomGive : true as bool
            });
        }

        if(stage == "EventWorldType9t"){
            player.addGameStage("EventWorldType9");
            server.executeCommand("title " + player.name + " title {\"text\":\"Хранитель Вещей\",\"color\":\"green\",\"italic\":true}",true);
            server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
            player.sendMessage(Component.literal("[Cобытие] Вы не можете потерять вещи при смерти").setStyle(<constant:formatting:green>));
            player.updateCustomData({
                EventWorldSaveItems : true as bool
            });
        }
    }   

    //Logic of random events
    if(stage == "EventWorld"){
        var RandomStartEvent = level.random.nextFloat();
        var RandomSelectTypeEvent = level.random.nextFloat();
        var RandomFloatEvent = level.random.nextFloat();

        if(RandomStartEvent >= 0.4 && RandomStartEvent <= 0.6)
        {   
            //Negative
            if(RandomSelectTypeEvent <= 0.3){
                if(RandomFloatEvent <= 0.1){
                    player.addGameStage("EventWorldType1");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Смертельное прикосновение\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Любой полученный урон от мобов, будет смертельным !").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldDeadlyDamage : true as bool
                    });
                }
                if(RandomFloatEvent > 0.1 && RandomFloatEvent <= 0.2){
                    player.addGameStage("EventWorldType2");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Сильная слабость\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Любой урон по монстрам, будет уменшен на 50%").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldSmallDamage : true as bool
                    });
                }
                if(RandomFloatEvent > 0.2 && RandomFloatEvent <= 0.3){
                    player.addGameStage("EventWorldType3");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Проклятые предметы\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Если вы получите урон от мобов, случайные предмет из инвентаря будет удалён или выбрашен").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldCursedItem : true as bool
                    });
                }
                if(RandomFloatEvent > 0.3 && RandomFloatEvent <= 0.4){
                    player.addGameStage("EventWorldType4");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Плохое самочуствие\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] До конца дня на вас будут действовать негативные эффекты, которые вы будете получать каждые 1000 тиков").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldBadEffect : true as bool
                    });
                }
                if(RandomFloatEvent > 0.4 && RandomFloatEvent <= 0.5){
                    player.addGameStage("EventWorldType5");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Кровавая Луна\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Под эту кровавую луну, монстры станцуют на вашей могиле").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldBloodMoon : true as bool
                    });
                    server.executeCommand("enhancedcelestials setLunarEvent enhancedcelestials:super_blood_moon", true);
                }
                if(RandomFloatEvent > 0.5 && RandomFloatEvent <= 1.0){
                    player.addGameStage("EventWorldType6");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Взрывные приколы\",\"color\":\"red\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] При смерте мобы создают взрыв").setStyle(<constant:formatting:red>));
                    player.updateCustomData({
                        EventWorldExplosion : true as bool
                    });
                }
            }
            //Posetive
            if(RandomSelectTypeEvent >= 0.3 && RandomSelectTypeEvent <= 0.6){
                if(RandomFloatEvent <= 0.1){
                    player.addGameStage("EventWorldType7");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Сила Геркулеса\",\"color\":\"green\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Любой нанесённый вами урон будет увеличен на 50%").setStyle(<constant:formatting:green>));
                    player.updateCustomData({
                        EventWorldDoubleDamage : true as bool
                    });
                }
                if(RandomFloatEvent >= 0.1 && RandomFloatEvent <= 0.2){
                    player.addGameStage("EventWorldType8");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Подарки с небес\",\"color\":\"green\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] В течении длня вы будете получать случайные предметы").setStyle(<constant:formatting:green>));
                    player.updateCustomData({
                        EventWorldRandomGive : true as bool
                    });
                }
                /*if(RandomFloatEvent >= 0.2 && RandomFloatEvent <= 0.3){
                    player.addGameStage("EventWorldType9");
                    server.executeCommand("title " + player.name + " title {\"text\":\"Хранитель Вещей\",\"color\":\"green\",\"italic\":true}",true);
                    server.executeCommand("title " + player.name + " subtitle {\"text\":\"Cобытие\",\"color\":\"gray\",\"italic\":true}",true);
                    player.sendMessage(Component.literal("[Cобытие] Вы не можете потерять вещи при смерти").setStyle(<constant:formatting:green>));
                    player.sendMessage("[§68sixik/Developer§r] Увы но это сейчас не работает =(");
                    player.updateCustomData({
                        EventWorldSaveItems : true as bool
                    });*/
                }
            }
        }
    }
    
});

CTEventManager.register<GameStageRemoved>((event) => {
    var player = event.player;
    var stage = event.stage;

    var Effects = [
        "Effect1",
        "Effect2",
        "Effect3",
        "Effect4",
        "Effect5",
        "Effect6",
        "Effect7",
        "Effect8",
        "Effect9",
        "Effect10",
        "Effect11",
        "Effect12"
    ] as string[];

    if(stage == "EventWorldType4"){
        player.removeEffect(<mobeffect:minecraft:unluck>);
        player.removeEffect(<mobeffect:minecraft:slowness>);
        player.removeEffect(<mobeffect:minecraft:bad_omen>);
        player.removeEffect(<mobeffect:minecraft:hunger>);
        player.removeEffect(<mobeffect:minecraft:weakness>);
        player.removeEffect(<mobeffect:minecraft:mining_fatigue>);
        player.removeEffect(<mobeffect:minecraft:poison>);
        player.removeEffect(<mobeffect:minecraft:nausea>);
        player.removeEffect(<mobeffect:majruszsdifficulty:bleeding>);
        player.removeEffect(<mobeffect:stalwart_dungeons:spore>);
        player.removeEffect(<mobeffect:stalwart_dungeons:burning>);
        for i in Effects {
            player.getCustomData().remove(i);
        }
    }
});