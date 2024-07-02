<template>
    <header>
        <img src="../ResursP2/logo.png" alt="" class="logo">
        <nav>
            <NuxtLink class="nav-btn" to="/">Главная</NuxtLink>
            <NuxtLink class="nav-btn" to="/about">О проекте</NuxtLink>

            <template v-if="status == 'authenticated'">
                <NuxtLink class="nav-btn" to="/lk">Личный кабинет</NuxtLink>
                <NuxtLink v-if="session.role == 'admin'" class="nav-btn" to="/admin-panel">Админ-панель</NuxtLink>
                <NuxtLink class="nav-btn" to="/logout">Выйти</NuxtLink>
            </template>

            <template v-else>
                <NuxtLink class="nav-btn" to="/login">Вход</NuxtLink>
                <NuxtLink class="nav-btn" to="/register">Регистрация</NuxtLink>
            </template>

        </nav>
    </header>
    
    <div class="wrapper">
        <br>
        <main>
            <slot></slot>
        </main>
        <br>
    </div>
        
    <footer>
        <br><br>
        <p class="copyright">© Безопасный город, 2024</p>

        <ul>Телефон:
            <li>+7 3952 43-30-40</li>
        </ul>

        <br>

        <ul>Электронная почта:
            <li>info@br38.ru</li>
        </ul>

    </footer>
</template>

<script>
    export default defineNuxtComponent({
        async setup ()
        {
            const { status, getSession } = useAuth(); // импорт функции получения сессии из плагина sidebase-auth 
            const session = await getSession(); // получаем данные текущего пользователя из сессии

            return {
                status,
                session,
            }
        },
    })
</script>

<style>
    *{
        font-family: Arial, Helvetica, sans-serif;
    }

    header {
        background-color: #5fa7fa;
        height: 110px;
        border-radius: 0 0 20px 20px;
        display: flex;
    }

    .wrapper{
        padding-left: 100px;
        padding-right: 100px;
    }

    header .logo{
        width: 150px;
        margin: 10px;
        border-radius: 20px;
    }

    footer {
        background-color: #5fa7fa;
        border-radius: 20px 20px 0 0;
        height: 200px;
    }
    
    footer ul li {
        list-style-type: none;
    }

    .copyright {
        text-align: center
    }

    .nav-btn {
        display: inline-block;
        padding: 10px;
        color: #fff;
        font-size: 24px;
        text-decoration: none;
        padding-top: 40px;
    }

</style>