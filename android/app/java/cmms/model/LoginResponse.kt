package cmms.model

data class LoginResponse(
    val status: Boolean,
    val message: String,
    val token: String,
    val user: User
)

data class User(
    val id: Int,
    val name: String,
    val email: String
)