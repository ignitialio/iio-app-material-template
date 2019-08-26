<template>
  <div class="login-layout">
    <v-card hover dark class="login-card">
      <v-card-title>
        <div class="login-headline">{{ $t('Sign in') }}</div>
        <div>{{ $t('Sign into your account')}}</div>
      </v-card-title>

      <v-card-text>
        <form @submit.stop.prevent="handleSubmit">
          <v-text-field dark :label="$t('Username')" v-model="username" required>
          </v-text-field>

          <v-text-field
            :append-icon="e1 ? 'visibility' : 'visibility_off'"
            @click:append="tooglePasswordVisibility"
            :type="e1 ? 'password' : 'text'"
            :label="$t('Password')" v-model="password"
            required>
          </v-text-field>

          <div class="login-actions">
            <v-btn type="submit" text color="blue"
              v-bind:disabled="!valid">{{ $t('Sign in') }}</v-btn>
          </div>
        </form>
      </v-card-text>
      <v-card-actions>

      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      username: '',
      password: '',
      e1: true
    }
  },
  computed: {
    valid() {
      return this.username !== '' && this.password !== ''
    }
  },
  methods: {
    handleSubmit() {
      this.$services.auth.signin(this.username, this.password).then(token => {
        this.$services.emit('app:signin', token)
        // console.log(token)
      }).catch(err => console.log(err))
    },
    handleSignUpClick() {
      this.$router.push('/signup')
    },
    tooglePasswordVisibility() {
      this.e1 = !this.e1
    }
  },
  mounted() {
    // wait for authentication service
    this.$services.waitForService(this.$config.auth.service).then(authService => {
      this.$ws.resetLocalCredentials()
    }).catch(err => console.log(err))
  }
}
</script>

<style>
.login-layout {
  width: 100%;
  height: 100%;
  display: flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}

.login-card {
  margin: 4px;
  width: 400px;
  max-height: calc(100% - 2em);
  overflow-y: auto;
  background-color: rgba(0, 0, 0, 0.7)!important;
  color: gainsboro!important;
}

.login-headline {
  width: 100%;
  font-size: 1.5em;
}

.login-actions {
  width: 100%;
  display: flex;
  flex-flow: row;
  justify-content: space-around;
  align-items: center;
}
</style>
