<template>
  <v-flex xs7>
    <v-card class="card--flex-toolbar">
      <v-toolbar card class="light-blue">
        <v-toolbar-title class="white--text">Information</v-toolbar-title>
      </v-toolbar>
      <v-list>
        <v-list-tile>
          <v-list-tile-title>
            Name
          </v-list-tile-title>
          <v-list-tile-content>
            {{ name }}
          </v-list-tile-content>
        </v-list-tile>
  
        <v-list-tile>
          <v-list-tile-title>
            Surname
          </v-list-tile-title>
          <v-list-tile-content>
            {{ surname }}
          </v-list-tile-content>
        </v-list-tile>
  
        <v-list-tile>
          <v-list-tile-title>
            Price
          </v-list-tile-title>
          <v-list-tile-content>
            {{ totalPrice }}
          </v-list-tile-content>
        </v-list-tile>

        <v-list-tile>
          <v-list-tile-title>
            Owner
          </v-list-tile-title>
          <v-list-tile-content>
            {{ coinbase }}
          </v-list-tile-content>
        </v-list-tile>

        <v-list-tile>
          <v-list-tile-title>
            Initiate Sale
          </v-list-tile-title>
          <v-list-tile-content>
            <v-text-field label="Buyers address (can be 0)" single-line v-model="addressTo"></v-text-field>
          </v-list-tile-content>

          <v-list-tile-action>
            <v-btn primary dark @click.native="startSale">Set</v-btn>
          </v-list-tile-action>
        </v-list-tile>

        <v-list-tile>
          <v-list-tile-title>
            Complete Sale
          </v-list-tile-title>
          <v-list-tile-content>
            <v-text-field label="Enter price" single-line v-model.number="buyPrice"></v-text-field>
          </v-list-tile-content>

          <v-list-tile-action>
            <v-btn primary dark @click.native="executeSale">Buy</v-btn>
          </v-list-tile-action>
        </v-list-tile>

        <v-list-tile>
  
          <v-spacer></v-spacer>
  
          <v-list-tile-action>
            <v-btn primary dark @click.native="getPriceClause">Get Clause</v-btn>
          </v-list-tile-action>

          <v-spacer></v-spacer>

          <v-list-tile-action>
            <v-btn primary dark @click.native="stopSale">Cancel Sale</v-btn>
          </v-list-tile-action>
        
        </v-list-tile>
  
  
      </v-list>
  
    </v-card>
  </v-flex>
</template>
<script>
import { CONTRACT } from '../contract'

export default {
  data () {
    return {
      coinbase: 0x00,
      name: 0,
      surname: 0,
      totalPrice: 0,
      addressTo: null,
      buyPrice: null      
    }
  },

  mounted () {
    this.getDataAsset()  
    var x = CONTRACT.PriceChanged() 
    x.watch((err, res) => {
      if(!err) {
        this.getDataAsset() 
      }
      console.log(err)
    })
  },

  methods: {

    getDataAsset() {
      CONTRACT.getData((err, res) => {
      if(!err) {
        this.name = res[0]
        this.surname = res[1]
        this.totalPrice = web3.fromWei(res[2], 'ether').toNumber()
        this.coinbase = res[3]
      }
      console.log(err)
    })
    },

    getPriceClause() {
      CONTRACT.getClause((err, res) => {
      if(!err) {
        alert(web3.fromWei(res, 'ether').toNumber() + ' ether')
      }
      console.log(err)
    })
    },
    
    startSale() {
      if(this.addressTo == 0) {
        this.addressTo = '0x0000000000000000000000000000000000000000'
      }
      if(!web3.isAddress(this.addressTo)) {
        alert('Invalid address!')
        this.addressTo = null
        return
      }

      CONTRACT.initiateSale(this.addressTo, (err, res) => {
        if(!err){
            console.log(res)
          }
          console.log(err)
          this.addressTo = null          
      })
    },

    stopSale() {
      CONTRACT.cancelSale((err,res) => {
        if(!err){
            console.log(res)
          }
          console.log(err)
      })
    },

    executeSale() {
      if(!_.isNumber(this.buyPrice) || this.buyPrice != this.totalPrice) {
        alert('Invalid Price!')
        this.buyPrice = null
        return
      }

      CONTRACT.completeSale({value:web3.toWei(this.buyPrice, 'ether')}, (err, res) => {
        if(!err) {
          console.log(res)
          this.buyPrice = null
        }
        console.log(err)
      })
    }
    

  }
}
</script>

