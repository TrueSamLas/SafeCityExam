<template>
	<br>
	<H1>Личный кабинет</H1>

	<hr>

	<table border>
		<tr v-for="(value, prop) in user">
			<td class="props">{{ prop }}</td>
			<td>{{ value }}</td>
		</tr>
	</table>

	<br>
	<hr>
	<br>

	<H2>Создать заявление:</H2>
	
	<form @submit.prevent="createForm" class="addform">
		<div>
			<label>
				<div class="zagolovki">Заголовок</div>
				<input type="text" v-model="create_form.title" required class="addtexttoforms">
			</label>
		</div>
		
		<div>
			<label>
				<div class="zagolovki">Адрес</div>
				<input type="text" v-model="create_form.adress" required class="addtexttoforms">
			</label>
		</div>

		<div>
			<label>
				<div class="zagolovki">Описание</div>
				<textarea v-model="create_form.desc" required class="addtexttoforms"></textarea>
			</label>
		</div>

		<div>
			<label>
				<div class="zagolovki">Изображение</div>
				<input
					type="file"
					accept=".png,.jpg,.jpeg"
					@input="convertImageToBase64"
					class="addtexttoforms">

				<img v-if="create_form.image" :src="create_form.image">
			</label>
		</div>

		<div>
			<button class="btnsend">
				{{ wait ? '...' : 'Отправить' }}
			</button>
		</div>
	</form>

	<br>
	<hr>
	<br>

	<h2>Заявления</h2>
	<table border>
		<tr>
			<th>ID</th>
			<th>Заголовок</th>
			<th>Адрес</th>
			<th>Описание</th>
			<th>Изображение</th>
			<th>Статус</th>
		</tr>

		<tr v-for="form in forms">
			<td>{{ form.id }}</td>
			<td>{{ form.title }}</td>
			<td>{{ form.adress }}</td>
			<td>{{ form.desc }}</td>
			<td>
				<img
					v-if="form.image"
					:src="form.image"
					width="200">
			</td>
			<td>{{ form.status }}</td>
		</tr>
	</table>
	
	<br><br>
</template>

<script>
	export default defineNuxtComponent({
		async setup()
		{
			definePageMeta({
				middleware: 'auth', // Пускать только авторизованных пользователей
			});

			const { getSession } = useAuth(); // импорт функции получения сессии из плагина sidebase-auth
			const session = await getSession(); // получаем данные текущего пользователя из сессии

			return {
				session,
			}
		},
		data()
		{
			return {
				forms: [],

				create_form: {
					title: '',
					adress: '',
					desc: '',
					image: '',
				},

				wait: false,
			};
		},
		computed: {
			user()
			{
				const { email, name, surname, patronymic, phone } = this.session; // берём из сессии только нужные поля
				return { email, name, surname, patronymic, phone };
			},
		},
		methods: {
			async loadForms()
			{
				this.forms = await $fetch('/api/forms'); // запрос на загрузку наших заявок
			},

			async createForm()
			{
				const success = await $fetch('/api/forms/create', { // запрос на создание заявки
					method: 'POST',
					body: {
						form: this.create_form,
					},
				});

				if( success ){
					for(let prop in this.create_form){ // очищаем форму, перебором всех свойств
						this.create_form[prop] = '';
					}

					this.loadForms(); // обновляем список заявок
				}else{
					alert('Ошибка!');
				}
			},

			convertImageToBase64(e)
			{
				const reader = new FileReader(); // создаём file reader
				reader.readAsDataURL(e.target.files[0]); // загружаем первый файл из input в формате dataURL
				reader.onload = () => {
					this.create_form.image = reader.result; // обновляем картинку
				}
			},
		},
		mounted()
		{
			this.loadForms(); // загружаем заявки при загрузке страницы
		},
	})
</script>

<style>
	table {
		border: 0;
		display: inline-block;
	}

	table td {
		border: 10;
		padding: 10px;
	}

	.addtexttoforms {
		padding: 10px;
		width: 300px;
		height: 60px;
	}

	.props {
		text-transform: capitalize;
		font-weight: 600;
		border-radius: 20px 0 0 20px;
	}

	.btnsend {
		padding: 20px;
		border-radius: 20px;
		border: none;
		background-color: #5fa7fa;
		cursor: pointer;
		width: 200px;
		/* position: absolute;
		right: 1000px;
		top: 500px; */
	}

	.addform {
		display: flex;
		gap: 30px;
	}
	
	.zagolovki {
		text-align: center
	}
</style>