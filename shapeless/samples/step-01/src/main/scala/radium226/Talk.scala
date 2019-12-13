package radium226

trait Talk[A] {

  def talk(a: A): String

}

object Talk {

  def apply[A: Talk]: Talk[A] = implicitly

}
