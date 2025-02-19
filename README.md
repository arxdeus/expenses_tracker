# expenses_tracker



https://github.com/user-attachments/assets/0e813d4a-0668-4b51-8d5b-d97eb4161c4b



## Фичи
- Создание кастомных категорий: своё фото, название
- Умное создание транзакций: нельзя создать транзакцию на 0$, тип транзакции подставляется автоматически в зависимости от указанной суммы
- Крутямбовые анимации
- Стильный дизайн
- Курсорная пагинация для любого исчисляемого энтити (но имплементирован только updateAt курсор, лел)
- Кастомный Decimal и кастомной логикой парсинга значения

## Технические нюансы
- На вебе при создании категории и выборе картинки выпадет ошибка, дело в том что мы выбираем и сохраняем локально картинку, т.е в БД и кэш, а в вебе своего кэша по-умолчанию нет
- Категории не всегда обновляются после добавления транзакции
- Изначально хотелось сделать всё в ажуре, но сроки слишком сжатые, к тому же это __ТЕСТОВОЕ__ задание, поэтому я не выносил стили в отдельный пакет/файл/тему
- Отсутсвует смена темы, цвета захардкожены
- Локализация вынесена в отдельный пакет, но её функциональность не имплементирована - zaebalsa
- Используется собственный стейт-менеджер (в pub.dev он под verified publisher, так что по правилам)

### Технические требования:

- [x] Создание экрана для добавления новых транзакций: Пользователь должен иметь возможность указать тип транзакции (расход или доход), сумму транзакции, категорию (питание, развлечения, транспорт и т.д.) и дату. Добавленные транзакции должны сохраняться в приложении.
- [x] Экран просмотра списка транзакций: Разработайте экран, который будет отображать список всех добавленных пользователем транзакций. Каждая транзакция должна содержать информацию о типе, сумме, категории и ~~дате~~.
- [ ] ~~Статистика и диаграммы: Реализуйте экран с общей статистикой по расходам и доходам. Включите графическую диаграмму, отображающую соотношение расходов и доходов по категориям.~~

Это сложный кейс, __зачем его пихать в тестовое__?
- [x] Сохранение данных: Обеспечьте сохранение данных о транзакциях между сеансами работы с приложением.

_Примечание_: drift + sqlite в качестве локального хранилища
- [x] Пользовательский интерфейс: Создайте привлекательный и интуитивно понятный дизайн приложения для удобства пользователей.

_Примечание:_ Имхо, UI сделан на уровне, согласитесь
- [X] Допустимо использовать только “Published by a pub.dev verified publisher” на https://pub.dev/

_Примечание:_ пришлось свой стейт-менеджмент завести под verified published, но, судя по всему, это ок
