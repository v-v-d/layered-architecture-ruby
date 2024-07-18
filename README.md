# Слоистая архитектура
Этот проект представляет собой пример слоистой архитектуры в Ruby, разработанной для управления корзиной покупок. Проект структурирован таким образом, чтобы обеспечить четкое разделение бизнес-логики, прикладного уровня и адаптеров, что способствует легкости поддержки, тестирования и расширения.

## Структура проекта
Структура каталогов проекта организована следующим образом:
```
carts
└── src
    └── app
        ├── adapters                      # adapters layer
        │   ├── auth_system.rb
        │   ├── gateways
        │   │   ├── carts.rb
        │   │   ├── items.rb
        │   │   ├── products.rb
        │   │   └── unit_of_work.rb
        │   └── rest
        │       ├── carts.rb
        │       ├── items.rb
        │       ├── main.rb
        │       └── view_models.rb
        ├── application                   # application layer
        │   ├── interfaces
        │   │   ├── auth_system.rb
        │   │   └── gateways
        │   │       ├── carts.rb
        │   │       ├── items.rb
        │   │       ├── products.rb
        │   │       └── unit_of_work.rb
        │   └── use_cases
        │       ├── add_item.rb
        │       ├── create_cart.rb
        │       └── retrieve_cart.rb
        ├── container.rb
        └── domain                        # domain layer
            ├── carts.rb
            └── items.rb
```

## Диаграмма зависимостей:
![dependency-graph.png](content%2Fdependency-graph.png)
 - **Доменный слой** полностью независимый. В нем содержится вся бизнес-логика приложения без IO операций.
 - **Прикладной слой** зависит только от доменного. Оркестрирует логику для достижения бизнес-цели. Он вызывает бизнес-логику, находящуюся в бизнес-сущностях и взаимодействует с другими компонентами системы через интерфейсы. Содержит IO операции.
 - **Слой адаптеров** зависит и от доменного слоя и от прикладного, а также зависит от конкретной библиотеки конкретной версии и протоколов передачи данных между системами. Содержит точки входа в систему и инструменты для взаимодействия с компонентами за пределами системы.

## Диаграмма потока управления
![control-flow.png](content%2Fcontrol-flow.png)
### Этапы Обработки Запроса

1. **Получение HTTP запроса**
   - Пользователь отправляет HTTP запрос на добавление товара в корзину (`шаг 1`).

2. **Обработка в Sinatra контроллере**
   - Запрос обрабатывается в `sinatra add_item controller` (`шаг 2`), который служит точкой входа для обработки HTTP запросов.

3. **Инициация Use Case**
   - Контроллер передает управление `AddItemToCartUseCase` (`шаг 3`), который координирует процессы бизнес-логики для добавления товара в корзину.

4. **Аутентификация пользователя**
   - В рамках UseCase происходит аутентификация пользователя через `FakeAuthSystem` (`шаги 4-7`). После успешной аутентификации процесс продолжается.

5. **Управление данными через UnitOfWork**
   - `InMemoryUnitOfWork` инициирует транзакцию для управления состоянием данных (`шаги 8-12`).

6. **Обращение к хранилищу корзины и товаров**
   - `InMemoryCartsGateway` используется для получения данных корзины (`шаги 13-18`).

7. **Получение информации о продуктах**
   - `HTTPartyProductsGateway` делает запрос к внешнему сервису для получения детальной информации о продуктах (`шаги 19-24`).

8. **Управление данными через UnitOfWork**
   - `InMemoryUnitOfWork` инициирует транзакцию для управления состоянием данных (`шаги 25-29`).

9. **Обращение к хранилищу корзины и товаров**
   - `InMemoryItemsGateway` вызывается для управления информацией о товарах, которые будут добавлены в корзину. UseCase обновляет данные корзины и завершает транзакцию через UnitOfWork (`шаги 30-34`).

10. **Формирование ответа**
   - По завершении обработки UseCase формирует `OutputDTO` с данными обновлённой корзины (`шаг 35`).

11. **Подготовка данных, согласно контракту между хттп клиентом и сервером**
    - Контроллер получает данные от UseCase, перенаправляет данные во `ViewModel` и адаптирует их согласно контракту (`шаги 36-37`).

12. **Отправка ответа пользователю**
    - Контроллер получает данные от ViewModel и формирует HTTP ответ (`шаг 38`).

13. **Завершение запроса**
    - HTTP ответ отправляется пользователю, завершая цикл обработки запроса (`шаг 39`).

## Запуск проекта
Система поддерживает контейнеризацию. Чтобы собрать и запустить текущий проект необходимо выполнить команду:
 ```shell
 docker-compose up --build -d
 ```
У системы есть 3 хттп эндпоинта:
1. Создать корзину
    ```bash
    curl --location --request POST 'http://0.0.0.0:8000/api/v1/carts' --header 'Authorization: Bearer test.test.test' --header 'Content-Type: application/json'
    ```
2. Добавить в корзину товар
    ```bash
    curl --location --request POST 'http://0.0.0.0:8000/api/v1/carts/<id корзины из запроса 1>/items' --header 'Authorization: Bearer test.test.test' --header 'Content-Type: application/json' --data '{"product_id": 1, "qty": 2}'
    ```
3. Получить корзину
    ```bash
    curl --location 'http://0.0.0.0:8000/api/v1/carts/<id корзины из запроса 1>' --header 'Authorization: Bearer test.test.test' --header 'Content-Type: application/json'
    ```