<template>
  <v-flex xs12>
    <v-card class="card--flex-toolbar">
      <v-toolbar card class="light-blue">
        <v-toolbar-title class="white--text">Transfers</v-toolbar-title>
      </v-toolbar>
  
      <v-data-table :headers="headers" :items="items" hide-actions class="elevation-1">
        <template slot="items" slot-scope="props">
          <td class="text-xs-left">{{ props.item.date }}</td>
          <td class="text-xs-center">{{ props.item.blockNumber }}</td>
          <td class="text-xs-left">{{ props.item.to }}</td>
          <td class="text-xs-left">{{ props.item.from }}</td>
          <td class="text-xs-right">{{ props.item.amount }}</td>
        </template>
      </v-data-table>
  
    </v-card>
  </v-flex>
</template>
<script>
import { CONTRACT } from '../contract'
export default {
  data () {
    return {
      headers: [
        { align: 'left', text: 'Date', value: 'date' },
        { align: 'left', text: 'Block No.', value: 'blockNumber' },
        { align: 'left', text: 'New', value: 'to' },
        { align: 'left', text: 'Old', value: 'from' },
        { align: 'left', text: 'Price', value: 'amount' }
      ],
      items: []
    }
  },
  mounted () {
    CONTRACT.Transfer({}, { fromBlock: 0, toBlock: 'pending' }, (err, res) => {
      if (res.args.to === CONTRACT._eth.coinbase || res.args.from === CONTRACT._eth.coinbase) {
          console.log(res)
        this.items.push({
          date: Date(res.args.saleDate * 1000),
          blockNumber: res.args._blockNumber,
          to: res.args.to,
          from: res.args.from,
          amount: web3.fromWei(res.args._salePrice).toNumber()
        })
      }
    })
  }
}
</script>
