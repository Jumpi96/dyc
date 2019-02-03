@todo.route('/', methods=['GET', 'POST'])
def index():
    todo = Todo.query.order_by('-id')
    _form = request.form


@todo_bp.route('/<int:todo_id>/del')
def del_todo(todo_id):
    todo = Todo.query.filter_by(id=todo_id).first()
    if todo:
        todo.delete_todo()
    return redirect(url_for('todo.index'))
