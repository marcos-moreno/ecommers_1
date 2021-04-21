<template>
 <v-container class="grey lighten-5">
    <v-row no-gutters>
      <v-col  >
        <v-card
          class="mx-auto"
        >
          <v-img width="700px" :src="producto.img">
          </v-img>
          <v-card-title>{{producto.name}}</v-card-title>
      
          <v-card-subtitle class="pb-0">
            {{producto.description}}
          </v-card-subtitle>
      
        <v-simple-table>
          <template v-slot:default>
            <thead>
              <tr>
                <th class="text-left">DISPONIBLE</th>
                <th class="text-left">PRECIO</th>
                <th class="text-left">UNIDAD</th>
                <th class="text-left">CÓDIGO</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>{{producto.mex_quantytotal}}</td>
                <td>${{producto.l0}}</td>
                <td>{{producto.unidad}}</td>
                <td>{{producto.value}}</td>
              </tr>
            </tbody>
          </template>
        </v-simple-table>  
        </v-card>
    </v-col>

    <v-col > 
    


        <template> 
            <v-container >
              <v-row>
                <v-col class="justify-center">
                      <div>Cantidad de la Compra  
                      <v-overflow-btn
                      class="my-2"
                      :items="qty"
                      label="Selecciona Una Cantidad"
                      ></v-overflow-btn>
                      </div>   
                      
                    <v-card-actions>
                        <v-btn 
                          class="mx-auto"
                          width="100%" large color="primary"  >
                          Comprar Ahora
                        </v-btn>  
                    </v-card-actions>
                    <v-card-actions>
                          <v-btn  
                            class="mx-auto" 
                            width="100%" large color="#D7ECF9"  >
                            Agregar Al Carrito
                          </v-btn>      
                    </v-card-actions>      
                    
                </v-col>
              </v-row>
            </v-container> 
        </template> 

      </v-col> 

    </v-row>
  </v-container>
</template>


 

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'

  export default {
    name:"appProducto",
    props: ['value'], 
    data() {
      return { 
          qty : []
         ,producto : {value:0}
      }
    },
    async mounted() {    
      window.scrollTo(0,0);
    },
    async created(){
       this.producto = await axios.get(config.apiAdempiere + "/productos/productByValue"
      ,{params: {value:this.value}}
      )
      .then(function (response) { 
        if (response.data.status == "success") {
          return response.data.data[0];
        } else {
          console.log(response.data.data);
          return [];
        }
      }).catch(function (response){ 
        console.log(response);
        return [];
      });   
      
      this.producto.img = 'data:image/jpeg;base64,' + 
      btoa(
        new Uint8Array(this.producto.img.data).reduce((data, byte) => data + String.fromCharCode(byte), '')
      ); 
      
      if (this.producto.mex_quantytotal > 0) {
        for (let index = 1; index <= this.producto.mex_quantytotal; index++) {
          this.qty.push(index);
        }
      }   
    }
  }
</script>