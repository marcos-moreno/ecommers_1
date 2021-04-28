<template> 
  <v-container class="grey lighten-5" style="min-height:756px;"  >
    <div class="text-center">
      <v-dialog v-model="isLoad" persistent width="300">
         <v-card color="primary" dark >
          <v-card-text>
            cargando
            <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
          </v-card-text>
        </v-card> 
      </v-dialog>
    </div>
    <template >
       <v-container v-if="isPay==false" style="min-height:656px;">
          <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
              ¿Dónde recolectarás tu compra?
            </p>  
            <v-img class="mx-auto text-center" width="70" src="../../public/tienda.png" ></v-img> 
            <v-radio-group v-model="sucursalSelec">  
              <v-simple-table >
                <template v-slot:default>
                  <thead>
                    <tr> 
                      <th class="text-left"></th>
                      <th class="text-left"></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="sucursal in sucursales" :key="sucursal.value"> 
                      <td><v-radio :label="sucursal.name" :value="sucursal.ad_org_id" ></v-radio></td>
                      <td>
                        <a target="_blank"  :href="sucursal.url_maps">
                        <v-btn text color="primary"> 
                        <v-img width="20" src="../../public/ubicacion.png" ></v-img>
                        </v-btn>  
                        </a>
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table> 
              <br><br><br>
              <v-row>  
                <v-col class="mx-auto text-center"> 
                  <v-btn :disabled="sucursalSelec==0" @click="pay" class="mx-auto" color="primary" width="50%" large>
                    CONTINUAR
                  </v-btn>            
                </v-col> 
              </v-row> 
            </v-radio-group>
          </v-card>  
      </v-container>

     <v-container v-if="isPay==true" style="min-height:656px;">
          <v-card style="min-height:186px;"> 
               <div id="paypal-button-container"></div> 
          </v-card>  
      </v-container>
 
    </template>

    <v-container v-if="shopingcarlength == 0 && isLoad == false"  style="min-height:656px;"  >
      <div>
        <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
              Tu cesta está vacía
            </p> 
        </v-card> 
      </div>  
    </v-container>

  </v-container>  
</template>

<style scoped>
    .centered-input >>> input {
      text-align: center
    }
</style>

 <!-- Include the PayPal JavaScript SDK -->
<script>
  // // Render the PayPal button into #paypal-button-container
  // paypal.Buttons({

  //     // Set up the transaction
  //     createOrder: function(data, actions) {
  //         return actions.order.create({
  //             purchase_units: [{
  //                 amount: {
  //                     value: '88.44'
  //                 }
  //             }]
  //         });
  //     },

  //     // Finalize the transaction
  //     onApprove: function(data, actions) {
  //         return actions.order.capture().then(function(details) {
  //             // Show a success message to the buyer
  //             alert('Transaction completed by ' + details.payer.name.given_name + '!');
  //         });
  //     }


  // }).render('#paypal-button-container');
</script>

<script>
import config from '../json/config.json'
import axios from 'axios'; 
export default {
  name: "appBuy",
  data() {
    return { 
      sucursalSelec : 0,
      page: 1,
      productos : [],
      isLogged : false,
      user : {},
      isLoad : false, 
      msgErro : "",
      sucursales : [],
      isPay : false, 

    }; 
  }, 
  async created() {
    this.isLoad = true;  
    await this.validaLogin();
    if (this.isLogged) {
      await this.allSucursales();
      await this.allProductinCar();
    }else{
      this.menu('/shop/Login/');  
    } 
    this.isLoad = false;  
  }

  ,methods: { 
    pay(){
      this.isPay = true;
    },
    async mounted() {    
      window.scrollTo(0,0);
    },
    menu(path){
      if (this.$route.path !== path){
        this.$router.push(path);
      }  
    }, 
    async eliminarProducto(producto){
      this.isLoad = true;   
      await axios.delete(config.apiAdempiere + "/shopingcar/deletebyvalue_auth", 
      {
        headers:{token: this.$cookie.get('token')},
        data:{value: producto.value}
      })
      .then(res=>{ 
        if(res.data.status != "success"){
          console.log(res.data);
        } 
      }).catch(err=>{return console.log(err);});  
      await this.allProductinCar(); 
      document.getElementById("cantidadInCar").value = this.productos.length == 0?"":this.productos.length;
      this.isLoad = false;   
    },
    isInt(value) {
      var x;
      return isNaN(value) ? !1 : (x = parseFloat(value), (0 | x) === x);
    },
    completarComprar(){ 
      if (!this.validarProductos()) {
        this.msgErro = "La cantidad de algun producto de tu carrito no es válida.";
      }else{
        this.msgErro = "";
        this.$router.push('/shop/Buy/')
      }
    },
    validarProductos(){
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          if (!this.isInt(element.cantidad) != element.cantidad < 1 || element.cantidad ==  "") {
            return false;
          }  
        } catch (error) {
          return false; 
        }
      }
      return true;
    },async qtyMovement(producto,vl){    
      this.isLoad = true;  
      try {
        if (this.isInt(producto.cantidad)) {
          if (vl == '+') {
            producto.cantidad = parseInt(producto.cantidad) + 1;
          }else  if (vl == '-') {
            if (parseInt(producto.cantidad) > 1) {
                producto.cantidad = parseInt(producto.cantidad) - 1;
            }
          } 
        }else{
          if (producto.cantidad != "") {
            producto.cantidad = 0;
          }else{
            producto.price = 0.0;
            if (vl == '+') {
              producto.cantidad = 1;
            }else  if (vl == '-') { 
              producto.cantidad = 0;
            } 
          }
        }  
      } catch (error) { 
        console.log(error);
        producto.cantidad = 1;
      } 
        
      if (producto.cantidad != "" && this.isInt(producto.cantidad) ) {
        if(parseInt(producto.cantidad) > 0){
          await axios.put(config.apiAdempiere + "/shopingcar/updatebyvalue_auth", 
          {value: producto.value,cantidad : producto.cantidad}
          ,{headers:{'token': this.$cookie.get('token')}})
          .then(res=>{ if(res.data.status != "success")console.log(res.data);})
          .catch(err=>{return console.log(err);});     
          producto.price = producto.l0 * parseInt(producto.cantidad);
        } 
      } 

      if (!this.validarProductos()) {
        this.msgErro = "La cantidad de algun producto de tu carrito no es válida.";
      }else{
        this.msgErro = "";
      }

      this.isLoad = false;  
    }
    ,async validaLogin(){
         this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {'headers': { 'token': this.$cookie.get('token') }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});    
        if (this.user.status == "success") {
          this.user = this.user.user; 
          this.isLogged = true;
        }else if(this.user.status == "unauthorized"){ 
          this.isLogged = false;
        }  
    }
    ,async allProductinCar(){
        let productsincar = await axios.get(config.apiAdempiere + "/shopingcar/getcomplete_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (productsincar.status == "success") {
          productsincar = productsincar.data;
        }else if(this.user.status == "unauthorized"){  
          productsincar = [];
        } 
        for (let index = 0; index < productsincar.length; index++) { 
            productsincar[index].price = productsincar[index].l0 * productsincar[index].cantidad; 
            productsincar[index].img = 'data:image/jpeg;base64,' + btoa(
                new Uint8Array(productsincar[index].img.data)
                .reduce((data, byte) => data + String.fromCharCode(byte), '')
            );  
        } 
        this.productos = productsincar;
    },
    async allSucursales(){
        this.sucursales = await axios.get(config.apiAdempiere + "/sucursal/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data.data;})
        .catch(err=>{return err;});  
    }  
    ,seeProduct(value){ 
      this.$router.push('/shop/Product/'+value+"/shopingcar/0");
    }
    ,formatMXN(value) {
        var formatter = new Intl.NumberFormat('es-MX', {style: 'currency', currency: 'MXN',});
        return formatter.format(value);
    }  
  }, 
  computed:{ 
      shopingcarlength(){
          return this.productos.length;
      },
      calculaTotalCar(){
        let total = 0;
        for (let index = 0; index < this.productos.length; index++) {
          const element = this.productos[index];
          total += element.cantidad * element.l0;
        }
        return this.formatMXN(total);
      },
  },
  watch: {
  
  } 
  
}
</script>
