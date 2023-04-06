import crafttweaker.api.entity.type.player.Player;
import crafttweaker.api.entity.LivingEntity;
import crafttweaker.api.entity.Entity;
import crafttweaker.api.world.Level;
import crafttweaker.api.world.ServerLevel;
import crafttweaker.api.data.IData;
import crafttweaker.api.data.MapData;
import crafttweaker.api.data.IntData;
import crafttweaker.api.data.ListData;
import crafttweaker.api.item.ItemStack;
import crafttweaker.api.item.IItemStack;
import crafttweaker.api.entity.type.player.Inventory;
import crafttweaker.api.world.Container;
import crafttweaker.api.ingredient.IIngredient;
import crafttweaker.api.block.BlockState;
import crafttweaker.api.block.Block;
import crafttweaker.api.util.math.BlockPos;


public class IPlayer {
    private static var player as Player;
    private static var level as Level;

    private static var RPosX as double;
    private static var RPosY as double;
    private static var RPosZ as double;

    
    private static var inventory as IItemStack[int] = {};

    public static randomTeleportPos(player as Player) as void{
        this.player = player;
        this.level = player.level;
        
        
    }

    public static RandomTeleport(player as Player, level as Level) as void {
        var randomX = level.random.nextInt(-3000000, 3000000);
        var randomZ = level.random.nextInt(-3000000, 3000000);
        var blockpos = new BlockPos(randomX, 20, randomZ);
        var use = true;

        player.teleportTo(randomX, 255, randomZ);
        while(use){
            if(!level.isLoaded(blockpos)){
                var teleport = PosTeleportCheck(player, level ,player.x as int + 1, player.y as int, player.z as int - 1);
                player.teleportTo(teleport[0], teleport[1], teleport[2]);
                use = false;
                break;
            }
        }
    }

    public static getRandomTeleportPos() as double[] {
        return [
            RPosX,
            RPosY,
            RPosZ
        ];
    }

    public static setSaveInventory(player as Player) as void {
        for i in 0 .. player.inventory.getContainerSize(){
            this.inventory[i] = player.inventory.getItem(i).asIItemStack();
        }
    }

    public static setSaveInventoryItem(player as Player, i as int) as void{
        this.inventory[i] = player.inventory.getItem(i).asIItemStack();
    }

    public static getSaveInvenortItem(i as int) as IItemStack {
        return inventory[i];
    }

    public static giveInventoryItem(player as Player, i as int) as void{
        player.inventory.setItem(i,inventory[i]);
    }



    public static clearVariables() as void {
        this.inventory = {};
    }
    
}

public function PosTeleportCheck(player as Player, level as Level, x1 as int, y1 as int, z1 as int) as int[]{

    var x = x1 - 1;
    var y = -64;
    var z = z1;
    var x2 = x+1;
    var z2 = z1+1;
    var t1 = 0;
    var t2 = 0;
    var t3 = 0;

    while(x < x2){
        while(y > -256){
            while(z < z2){
                    var AllPos =  new BlockPos(x, y, z);
                    var AllPosupup = new BlockPos(x, y+1, z);
                    var AllPosup = new BlockPos(x, y, z);
                    var AllPosdown = new BlockPos(x, y-1, z);
                    var block = level.getBlockState(AllPos);
                    var block1 = level.getBlockState(AllPosupup);
                    var block2 = level.getBlockState(AllPosup);
                    var block3 = level.getBlockState(AllPosdown);
                    if(block.block.registryName == <resource:minecraft:void_air> || block.block.registryName == <resource:minecraft:bedrock>){} else{
                        println(block.block.registryName);
                        println(AllPos.toString());
                        if(block1.block.registryName == <resource:minecraft:air> && block2.block.registryName == <resource:minecraft:air> && block3.block.registryName != <resource:minecraft:air>){
                            t1 = x;
                            t2 = y;
                            t3 = z;
                        }
                    }
                z++;
            }
            y++;
            z = z1;
        }
        x++;
        y = -63;
    }
    return [
        x,y,z
    ];
}

public function DestroyZone(player as Player, level as Level, x1 as int, y1 as int, z1 as int) as bool {
    var x = x1 - 1;
    var y = -64;
    var z = z1;
    var x2 = x + 3;
    var z2 = z1 + 3;
    var BlackList = [
        <item:minecraft:grass_block>,
        <item:minecraft:dirt>
    ] as IItemStack[];
    var Pos = [] as int[];
    while(x < x2){
        while(y < 255){
            while(z < z2){
                var AllPos = new BlockPos(x, y, z);
                var block = level.getBlockState(AllPos);
                if(block.block.registryName == <resource:minecraft:air> || block.block.registryName == <resource:minecraft:void_air> || block.block.registryName == <resource:minecraft:bedrock>){} else{
                    println(block.block.registryName);
                    println(AllPos.toString());
                    if(CheckBlock(block, BlackList)){
                        level.destroyBlock(AllPos, true);
                    }
                }
                z++;
            }
            y++;
            z = z1;
        }
        x++;
        y = -63;
    }
    return true;
}

public function CheckBlock(block as BlockState, blocks as IItemStack[]) as bool{
    if(blocks.isEmpty){
        blocks = [<item:minecraft:elytra>];
    }
    for i in blocks{
        if(block.block.registryName == i.registryName){
            return false;
        }
        else{
            return true;
        }
    }
}