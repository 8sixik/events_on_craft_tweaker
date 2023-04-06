import crafttweaker.api.events.CTEventManager;
import crafttweaker.api.entity.LivingEntity;
import crafttweaker.api.entity.EntityType;
import crafttweaker.api.entity.MobCategory;
import crafttweaker.api.entity.Entity;
import crafttweaker.api.data.IData;
import crafttweaker.api.util.math.Random;
import crafttweaker.api.data.IntData;
import crafttweaker.api.game.Server;
import crafttweaker.api.util.sequence.SequenceBuilder;
import crafttweaker.api.util.sequence.SequenceContext;
import crafttweaker.api.event.entity.player.PlayerLoggedInEvent;
import crafttweaker.api.data.MapData;
import crafttweaker.api.entity.EntityType;
import crafttweaker.api.event.entity.player.interact.RightClickItemEvent;
import crafttweaker.api.event.entity.player.PlayerRespawnEvent;
import mods.gamestages.events.GameStageAdded;
import crafttweaker.api.world.ServerLevel;
import crafttweaker.api.util.math.BlockPos;
import crafttweaker.api.entity.effect.MobEffectInstance;


//Issuing player data when logging in
CTEventManager.register<crafttweaker.api.event.entity.player.PlayerLoggedInEvent>((event) => {
    var player = event.player;
    var level = player.level;
    
    if(level.isClientSide) return;
    if("HaveCustomData" in player.getCustomData()){
        println("Give Data");
    }
    else{
        player.updateCustomData({
            isPlayer : true,
            HaveCustomData: true, 
            PlayerSetInfo : 0,
            PlayerWorldEvent: 0, 
            PlayerCursed: 0,
            PlayerKnowlesMobs : 0,
            PlayerKnowlesSkelets : 0,
            PlayerKnowlesZombie : 0,
            PlayerKnowlesCreeper : 0,
            PlayerKnowlesEnderMan : 0,
            PlayerKnowlesDramix : 0,
            StartEvent : true
        });
        println("Have Data");
    }

    if(!player.hasGameStage("dialog_1_end")){
        player.addGameStage("dialog_1_0");
    }

    if(GlobalRules.PlayerData){
        println(player.getCustomData().toString());
    }
});

CTEventManager.register<GameStageAdded>((event) => {
    var player = event.player;
    var stage = event.stage;

});

//Gives the date of the event at the respawn
CTEventManager.register<crafttweaker.api.event.entity.player.PlayerRespawnEvent>((event) => {
    var player = event.player;
    var level = player.level;

    if(level.isClientSide) return;
    if("HaveCustomData" in player.getCustomData()){}
    else{
        player.updateCustomData({
            isPlayer : true,
            HaveCustomData: true, 
            PlayerSetInfo : 0,
            PlayerWorldEvent: 0, 
            PlayerCursed: 0,
            PlayerKnowlesMobs : 0,
            PlayerKnowlesSkelets : 0,
            PlayerKnowlesZombie : 0,
            PlayerKnowlesCreeper : 0,
            PlayerKnowlesEnderMan : 0,
            PlayerKnowlesDramix : 0,
            StartEvent : true
        });
        println("Имеет Данные");
    }

    if("isPlayer" in player.getCustomData()){
        //Events
        {
            if(player.hasGameStage("EventWorldType1")){
                player.updateCustomData({
                    EventWorldDeadlyDamage : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType2")){
                player.updateCustomData({
                    EventWorldSmallDamage : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType3")){
                player.updateCustomData({
                    EventWorldCursedItem : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType4")){
                player.updateCustomData({
                    EventWorldBadEffect : true as bool
                });
                if(level.daytime >= 12000 && level.daytime <= 13000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:unluck>, 999999, 1));
                }
                if(level.daytime >= 13000 && level.daytime <= 14000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:bad_omen>, 999999, 1));
                }
                if(level.daytime >= 14000 && level.daytime <= 15000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:slowness>, 999999, 1));
                }
                if(level.daytime >= 15000 && level.daytime <= 16000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:hunger>, 999999, 1));
                }
                if(level.daytime >= 16000 && level.daytime <= 17000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:weakness>, 999999, 1));
                }
                if(level.daytime >= 17000 && level.daytime <= 18000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:mining_fatigue>, 999999, 1));
                }
                if(level.daytime >= 18000 && level.daytime <= 19000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:poison>, 999999, 1));
                }
                if(level.daytime >= 19000 && level.daytime <= 20000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:minecraft:nausea>, 999999, 1));
                }
                if(level.daytime >= 20000 && level.daytime <= 21000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:majruszsdifficulty:bleeding>, 999999, 1));
                }
                if(level.daytime >= 21000 && level.daytime <= 22000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:stalwart_dungeons:spore>, 999999, 1));
                }
                if(level.daytime >= 22000 && level.daytime <= 23000 || level.daytime < 23500){
                    player.addEffect(new MobEffectInstance(<mobeffect:stalwart_dungeons:burning>, 999999, 1));
                }
            }
            if(player.hasGameStage("EventWorldType5")){
                player.updateCustomData({
                    EventWorldBloodMoon : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType6")){
                player.updateCustomData({
                    EventWorldExplosion : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType7")){
                player.updateCustomData({
                    EventWorldDoubleDamage : true as bool
                });
            }
            if(player.hasGameStage("EventWorldType8")){
                player.updateCustomData({
                    EventWorldRandomGive : true as bool
                });
            }
        }
        //Data
        {

        }
           
    }
});
