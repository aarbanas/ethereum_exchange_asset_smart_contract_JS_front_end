<template>
  <v-flex xs5>
    <v-card class="card--flex-toolbar">
      <v-toolbar card class="light-blue">
        <v-toolbar-title class="white--text">Set price and clause</v-toolbar-title>
      </v-toolbar>
      <v-list>
        <v-list-tile>
          <v-list-tile-title>
            Price
          </v-list-tile-title>
          <v-list-tile-content>
  
            <v-text-field label="0.00" single-line v-model.number="price"></v-text-field>
  
          </v-list-tile-content>
        </v-list-tile>
  
        <v-list-tile>
          <v-list-tile-title>
            Clause
          </v-list-tile-title>
          <v-list-tile-content>
  
            <v-text-field label="0.00" single-line v-model.number="clause"></v-text-field>
  
          </v-list-tile-content>
        </v-list-tile>
  
        <v-list-tile>
  
          <v-spacer></v-spacer>
  
          <v-list-tile-action>
            <v-btn primary dark @click.native="setPriceClause">Set</v-btn>
          </v-list-tile-action>
        </v-list-tile>

        <v-list-tile>
          <v-list-tile-title>
            Item set on sale
          </v-list-tile-title>
          <v-list-tile-content>
  
            {{ sellingBol }}
  
          </v-list-tile-content>
        </v-list-tile>
  
      </v-list>
  
    </v-card>
  </v-flex>
</template>
<script>
import config from '../config'
import { CONTRACT } from '../contract'
import _ from 'lodash'

export default {
  data () {
    return {
      price: null,
      clause: null,
      coinbase: null,
      sellingBol: "No"
    }
  },

  mounted() {
    var x = CONTRACT.ChangeSelling()
    x.watch((err,res) => {
      if(!err){
        this.setTextForSelling()
      }
      console.log(err)
    })
  },

  methods: {
    setPriceClause() {

      if(!_.isNumber(this.price) || this.price <= 0) {
        alert('Invalid Price!')
        this.price = null
        return
      }

      if(!_.isNumber(this.clause) || this.clause <= 0) {
        alert('Invalid Clause!')
        this.clause = null
        return
      }     
      
      CONTRACT.setPrice(this.price,this.clause, (err,res) => {
          if(!err){
            console.log(res)
          }
          console.log(err)
          this.price = null
          this.clause = null
      })

    },

    setTextForSelling(){
      CONTRACT.selling.call((err,res) => {
        var test
        if(!err) {
          this.test = res
        }
        console.log(err)

        if(this.test == true) {
          this.sellingBol = "Yes"
        }
        else{
          this.sellingBol = "No"
        }
      })
    }
  }
}
</script>

