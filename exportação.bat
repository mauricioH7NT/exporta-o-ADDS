# Caminho para o arquivo de saída
$CaminhoCSV = "$env:USERPROFILE\Desktop\Usuarios_AD_Exportados.csv"

# Coletar todos os usuários do AD
$Usuarios = Get-ADUser -Filter * -Properties Name,SamAccountName,DistinguishedName,UserPrincipalName,EmailAddress,Department,Description,Title,WhenCreated,PasswordLastSet,AccountExpirationDate,Enabled,LockedOut,PasswordNeverExpires,TelephoneNumber,Company,City,AdminCount,pwdLastSet,LastLogonDate

# Lista para armazenar os resultados
$Relatorio = foreach ($User in $Usuarios) {
    # Exibe o nome do usuário processado
    Write-Host "Processando: $($User.Name)" -ForegroundColor Yellow

    $Grupos = (Get-ADPrincipalGroupMembership $User | Select-Object -ExpandProperty Name) -join "; "
    [PSCustomObject]@{
        Nome                  = $User.Name
        SamAccountName        = $User.SamAccountName
        UserPrincipalName     = $User.UserPrincipalName
        DistinguishedName     = $User.DistinguishedName
        Email                 = $User.EmailAddress
        Departamento          = $User.Department
        Descricao             = $User.Description
        Titulo                = $User.Title
        CriadoEm              = $User.WhenCreated
        UltimaAlteracaoSenha  = $User.PasswordLastSet
        ContaExpiraEm         = $User.AccountExpirationDate
        ContaHabilitada       = $User.Enabled
        ContaBloqueada        = $User.LockedOut
        SenhaNuncaExpira      = $User.PasswordNeverExpires
        TrocarSenhaProximoLogon = ($User.pwdLastSet -eq 0)
        Telefone              = $User.TelephoneNumber
        Empresa               = $User.Company
        Cidade                = $User.City
        ContaProtegida        = ($User.AdminCount -eq 1)
        Grupos                = $Grupos
        UltimoLogon           = $User.LastLogonDate
    }
}

$Relatorio | Export-Csv -Path $CaminhoCSV -NoTypeInformation -Encoding UTF8

Write-Host "Exportação concluída para: $CaminhoCSV" -ForegroundColor Cyan