//
//  GameScene.swift
//  BreakOut
//
//  Created by 井関竜太郎 on 2021/02/10.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var player : SKSpriteNode?
    private var ball : SKSpriteNode?
    private var blocks: SKNode?
    private var gameState : String?
    
    
    override func didMove(to view: SKView) {
        
        //衝突判定のdelegate
        self.physicsWorld.contactDelegate = self
        
        
        //ゲームステータス
        self.gameState = "START"
        //ブロック
        self.blocks = self.childNode(withName: "//BLOCKS")
        //ラベル
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        //プレイヤー
        self.player = self.childNode(withName: "//PLAYER") as? SKSpriteNode
        self.player!.physicsBody?.usesPreciseCollisionDetection = true
        //ボール
        self.ball = self.childNode(withName: "//BALL") as? SKSpriteNode
        self.ball!.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        //BLOCKに何かがぶつかったらブロックを消す
        if (contact.bodyA.node?.name == "BLOCK"){
            //パーティクル
            starParticle(node: contact.bodyA.node!)
            //ブロックを消す
            contact.bodyA.node?.removeFromParent()
        }else if(contact.bodyB.node?.name == "BLOCK" ){
            //パーティクル
            starParticle(node: contact.bodyB.node!)
            //ブロックを消す
            contact.bodyB.node?.removeFromParent()
        }
        //ブロックの数が0ならゲームクリア
        if(self.blocks!.children.count <= 0){
            self.gameClear()
        }
    }
    
    
    //星のパーティクル
    func starParticle(node:SKNode){
        //プレイヤー爆発 & 削除
        let star = SKEmitterNode(fileNamed: "star")
        star?.position.x = node.position.x
        star?.position.y = node.position.y - 200
        addChild(star!)
        
        //効果音再生Action
        let seAction:SKAction = SKAction(named: "HIT")!
        //待ちAction
        let waitAction:SKAction = SKAction.wait(forDuration: 1)
        //オブジェクトの削除Action
        // let removeAction:SKAction = SKAction.removeFromParent()
        //シーケンス
        let sequence:SKAction = SKAction.sequence([seAction, waitAction])
        //Action実行
        star?.run(sequence)
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(self.gameState == "START") {
            gameStart();
        }else if (self.gameState == "END") {
            backToStart()
        }
        
        
        for t in touches {
            //プレイヤーのxの位置を指の位置にする。
            self.player?.position.x = t.location(in: self).x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            self.player?.position.x = t.location(in: self).x
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if ( CGFloat((self.ball?.position.y)!) < -700) {
            if(self.gameState != "END") {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        self.gameState = "END"
        //Labelに表示
        self.label?.text = "GAME OVER"
        self.label?.run(SKAction(named: "GAMEOVER")!)
        //ボールの削除
        self.ball?.removeFromParent()
        //プレイヤーのさくぎょ
        self.player?.removeFromParent()
    }
    
    func gameClear() {
        self.ball?.removeFromParent()
        
        self.gameState = "END"
        self.label?.text = "GAME CLEAR"
        self.label?.run(SKAction(named: "GAMEOVER")!)
        
        //ステージクリアのパルクール
        let clear = SKEmitterNode(fileNamed: "clear")
        clear?.position.x = 0
        clear?.position.y = -500
        addChild(clear!)
        
    }
    
    
    
    
    
    func gameStart() {
        //ゲームステータスをプレイ中にする。
        self.gameState = "PLAY"
        //タイトルラベルを移動する。
        self.label?.run(SKAction(named: "GAMESTART")!)
        //スタート処理(ボールを動かす)
        let vector = CGVector(dx: 15, dy: -15)
        self.ball?.physicsBody?.applyImpulse(vector)
    }
    
    func backToStart() {
        //同じGameSceneを開き直す
        let transition = SKTransition.fade(withDuration: 2.0)
        //GameScene.swiftを読み込み
        let scene = GameScene(fileNamed: "GameScene")
        //Sceneを画面いっぱいに表示設定
        scene!.scaleMode = .aspectFill
        //遷移実行
        self.view!.presentScene(scene!, transition:transition)
    }
}
