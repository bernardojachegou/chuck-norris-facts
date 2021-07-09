# CN Facts application
[https://github.com/joelbanzatto/chuck-norris-facts](https://github.com/joelbanzatto/chuck-norris-facts)

## Tecnologias

### [CocoaPods](https://cocoapods.org/)
Responsável pela gerência das dependências do projeto.

### [RxSwift](https://github.com/ReactiveX/RxSwift)
Responsável pelo paradigma reativo, pela transição de dados e do fluxo de eventos entre view controllers e os view models.

### [Toaster](https://github.com/devxoul/Toaster)
Library utilizada para apresentação de mensagens não invasivas de UI na tela

### [PKHUD](https://github.com/pkluz/PKHUD)
Library para feedback visual de possíveis situações assíncronas ou que o usuário do app deva aguardar algum tipo de processamento.

### [SwiftLint](https://github.com/realm/SwiftLint)
Mantém o código limpo e garante a utilização de boas práticas por todas as pessoas colaboradoras.

## Arquitetura

### MVVM (model, view, viewmodel)
Bastante difundida na comunidade, é a forma que mais faz sentido para mim para tirar a respondabilidade do View Controller de lidar com input e output de informações, integrações com providers, apis.

### Coordinators
Um design pattern bem comum entre as pessoas desenvolvedoras, permite criar fluxos de navegação de forma isolada e lógica. Tem a responsabilidade de abrir telas e abrir outros subfluxos. Em um app com poucas telas talvez pareça over engineering, mas quando o app cresce, seu uso se torna necessário.

### View Code
É de minha preferência codificar as views de forma declarativa. Em uma equipe grande, os XIBs e os Storyboards começam a ficar difíceis de colaborar devido a complexidade de seus arquivos. Além disso, implementar componentes visuais de forma declarativa, deixa você mais especializado no UIKit.

Não utilizei SwiftUI pois minha produtividade ainda não é satisfatória.

### User Defaults
As informações desta aplicação são poucas, por isso, a implementação de algum banco de dados com ORM tornaria a tarefa mais complexa para a ocasião. 

### Bitrise

[Acesse o app CN Facts no Bitrise, clicando aqui](https://app.bitrise.io/app/a1e311c4dd1b4974#/)

Usado para a pipeline e integração contínua. Cada pull request aberto é gerada uma versão do app para teste de integração.

O Bitrise tem uma interface intuitiva e tem um wizard bem simples de configurar. Além de oferecer um bom plano grátis e uma excelente integração com o GitHub.

### GitHub Projects

[Acesse o Projeto, clicando aqui](https://github.com/joelbanzatto/chuck-norris-facts/projects/1)

A plataforma para Projetos do GitHub é bem versátil. Oferece uma rápida, simples e rica gama de opções e de customizações. Vai de um Scrum até um Kanban e permite configurar a sua maneira. Além de ser bem integrada ao próprio repositório. Direto ao ponto, trazendo solução.


## Rodando o projeto

1. navegue até a pasta do projeto
2. instale as dependências (`pod install`)
3. abra o arquivo com a extensão .xcworkspace
4. pressione CMD+R
5. divirta-se!
