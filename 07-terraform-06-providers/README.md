# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1.
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда:
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на гитхабе.   

```
/terraform-provider-aws/internal/provider/provider.go

#data_source lines 423-901
https://github.com/hashicorp/terraform-provider-aws/blob/3c1f58b59a45aaecc9a4b243d5b1004283b3353b/internal/provider/provider.go#L423
		DataSourcesMap: map[string]*schema.Resource{

# resource map следом 902-2063
ResourcesMap: map[string]*schema.Resource{

https://github.com/hashicorp/terraform-provider-aws/blob/3c1f58b59a45aaecc9a4b243d5b1004283b3353b/internal/provider/provider.go#L902

```

1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`.
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.

	> ConflictsWith: []string{"name_prefix"},

	https://github.com/hashicorp/terraform-provider-aws/blob/3c1f58b59a45aaecc9a4b243d5b1004283b3353b/internal/service/sqs/queue.go#L87

    * Какая максимальная длина имени?

	> 80 символов или 75 если заканчивается на ".fifo"

    * Какому регулярному выражению должно подчиняться имя?

		```
			if fifoQueue {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
		} else {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
		}
	```

## Задача 2. (Не обязательно)
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины.
Также вот официальная документация о создании провайдера:
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   


> не сделал

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
