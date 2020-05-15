require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, name TEXT, grade INTEGER
        )"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      update
    else
      sql = "INSERT INTO students (name, grade)
            VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)

      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students
          WHERE students.name == ?"
    new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def update
    sql = "UPDATE students
        SET name = ?, grade = ? WHERE id == ?"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
