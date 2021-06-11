<template>
  <v-footer padless >
    <v-card flat  width="100%"  tile class="black lighten-0 white--text text-center"
    >
      <v-card-text>
        <v-btn
          v-for="icon in icons"
          :key="icon"
          class="mx-4 white--text"
          icon
        >
          <v-icon size="24px">
            {{ icon }}
          </v-icon>
        </v-btn>
      </v-card-text>

      <v-card-text class="white--text pt-0">
        R-F HOODS & TRUCK PARTS SA DE CV Carretera Federal México Pachuca KM 30, Col. La Esmeralda, 55765 Tecámac, Estado de México, México
      </v-card-text>

      <v-divider></v-divider>

      <v-card-text class="white--text">
       &copy; {{ new Date().getFullYear() }} — <strong>Grupo Refividrio</strong>
       <p>Created by Marcos GMG</p>
      </v-card-text>
    </v-card>
  </v-footer>
</template>

<script>
  export default {
    data: () => ({
      icons: [
        'mdi-facebook',
        'mdi-twitter',
        'mdi-linkedin',
        'mdi-instagram',
      ],
    }),
  }
</script>