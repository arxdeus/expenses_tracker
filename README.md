# Expenses tracker

https://github.com/user-attachments/assets/7cbd0a1c-2267-49b5-801b-5af71c2b15c8

## Features
- Custom categories creation: use your own photo and title
- Smart transaction creation: you can't create a transaction for $0, the transaction type is substituted automatically depending on the specified amount
- Beatiful animations
- Stylish design
- Cursor pagination for any 'cursorable' entity (only `updateAt` cursor is implemented, lel)
- Custom `Decimal` and value parsing logic

## Technical nuances
- An error will appear on the web when creating a category and selecting an image, the fact is that we select and save the image locally, i.e. in the database and cache, but there is no default cache on the web.
- There's no change of theme, the colors are hardcoded
- Localization is included in a separate package, but its functionality is not implemented - TBD
- My own state manager is used - https://github.com/arxdeus/modulisto
