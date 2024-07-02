<template>
	<h1>Вход в аккаунт</h1>
	<form @submit.prevent="onSubmit" class="loginform">
		<br>
		<div>
			<label>
				<div>Email</div>
				<input type="email" v-model="form.email" required>
			</label>
		</div>

		<br>
		<div>
			<label>
				<div>Пароль</div>
				<input type="password" v-model="form.password" required>
			</label>
		</div>

		<br><br>

		<div>
			<button class="btnlogin">
				{{ wait ? '...' : 'Войти' }}
			</button>
		</div>
		<br>
	</form>
</template>

<script>
	export default defineNuxtComponent({
		setup()
		{
			const { signIn } = useAuth(); // импорт функции авторизации из плагина sidebase-auth

			definePageMeta({
				middleware: 'auth', // Подключаем плагин sidebase-auth
				auth: {
					unauthenticatedOnly: true, // Пускать только не авторизованных пользователей
        			navigateAuthenticatedTo: '/lk', // если авторизован, переадресовываем в личный кабинет
				},
			});

			return {
				signIn,
			};
		},
		data()
		{
			return {
				form: { // данные формы
					email: '',
					password: '',
				},

				wait: false, // флаг при отправке данных
			};
		},
		methods: {
			async onSubmit()
			{
				if( this.wait ) return; // если флаг, то не выполняем функцию ещё раз

				this.wait = true;

				const { error } = await this.signIn('credentials', { // авторизуем через sidebase-auth
					email: this.form.email,
					password: this.form.password,
					redirect: false,
				});

				if( error )
					alert('Неверный логин или пароль!');
				else
					return navigateTo('/lk'); // редирект в лк

				this.wait = false; // выключаем флаг
			},
		},
	})
</script>

<style>
	.loginform{
		text-align: center
	}

	.loginform input {
		width: 400px;
		height: 40px;
	}

	.btnlogin {
		padding: 20px;
		border-radius: 20px;
		border: none;
		background-color: #5fa7fa;
		cursor: pointer;
		width: 200px;
		font-size: 18px;
	}
</style>